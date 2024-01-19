module keyboard(
    input logic clk,
    input logic ps2d,
    input logic ps2c,
    input logic ack,
    output logic [15:0] dout
);

localparam [1:0] 
    IDLE = 2'b00,
    READ = 2'b01,
    PARSE = 2'b10,
    END =  2'b11;

logic [7:0] filter;
logic rx_done_tick;
logic [3:0] count;
logic [1:0] state;
logic [1:0] c;
logic fall_edge;
logic [10:0] char;
logic status;
logic key_released;

// Filter falling edge of ps2c
always_ff @(posedge clk)
begin
    filter <= {ps2c,filter[7:1]};
    if (filter == 8'b11111111)
        c<= {1'b1,c[1]};
    else if (filter == 8'b00000000)
        c <= {1'b0,c[1]};
end
 
assign fall_edge = c[0] & ~c[1];

// FSM
always_ff @(posedge clk)
begin
    rx_done_tick <= 1'b0;
    case (state)
        IDLE:
            if (fall_edge & ~status)
            begin
                char <= {ps2d, char[10:1]};
                count <= 4'd9;
                state <= READ;
            end

        READ:
            if (fall_edge)
            begin
                char <= {ps2d, char[10:1]};
                if (count == 0)
                    state <= PARSE;
                else
                    count <= count - 1;
            end

        PARSE:
            begin
                // Check if the key was released (F0 code)
                if (char[8:1] == 8'hF0)
                begin
                    key_released <= 1'b1;
                    state <= IDLE;  // Go back to IDLE to wait for the next key press
                end
                else if (key_released)
                begin
                    // Ignore the scan code following F0 and wait for next key press
                    key_released <= 1'b0;
                    state <= IDLE;
                end
                else
                    state <= END;
            end

        END:
            begin
                rx_done_tick <= 1'b1;
                state <= IDLE;
            end
    endcase
end

always_ff @(posedge clk)
    if (rx_done_tick)
        status <= 1'b1;
    else if (status == 1 & ack == 1)
        status <= 1'b0;

always_comb
    if (ack == 1'b1)
        dout = 16'(char[8:1]);  // Assign scan code
    else
        dout = 16'(status);

initial
begin
    status = 0;
    state = IDLE;
    key_released = 0;
end

endmodule
