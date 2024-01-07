module prj1(
    input logic [1:0] PushButtons,
    input logic clk,
    output logic [3:0] o_grounds,
    output logic [6:0] o_display	 
);
// This project was made by Abdulkerim Talha Timur, Tayfur Şafak Gencay, Kutay Başkurt.
  logic [15:0] data;
  logic [1:0] PushButtonStates;
  logic [1:0] LeftPushButtonBuffer;
  logic [1:0] RightPushButtonBuffer;
  logic [25:0] clk2;
  // State for clock setting control
  logic [1:0] clk_state; // 3 state
  logic [4:0] clk_setting; // Will hold the value of clk to be set (5 to 24)
  
  // Defination the states
  localparam CLK_15 = 0, CLK_19 = 1, CLK_25 = 2;
	

  sevensegment baseModule(
    .clk(clk),
    .din(data),
    .grounds(o_grounds),
    .display(o_display),
	 .clk_setting(clk_setting)
  );
  
  

  always_comb
  begin
  // clk_setting update 
  case (clk_state)
            CLK_15: clk_setting = 5'd15;
            CLK_19: clk_setting = 5'd19;
            CLK_25: clk_setting = 5'd25;           
            default: clk_setting = 5'd15;
endcase
  
  end
  // Clock divider
  always_ff @(posedge clk) begin
    clk2 <= clk2 + 1;
  end

  // Main logic for button press and data increment
  always_ff @(posedge clk2[16]) begin
    // Debounce logic
    LeftPushButtonBuffer <= {LeftPushButtonBuffer[0], PushButtons[0]};
    RightPushButtonBuffer <= {RightPushButtonBuffer[0], PushButtons[1]};

    // LEFT PUSHBUTTON
if (PushButtonStates[0] == 0 && LeftPushButtonBuffer == 2'b01) begin
        PushButtonStates[0] <= 1;
        // Check if already at maximum before incrementing
        if (data[3:0] != 4'hF) begin
            data[3:0] <= data[3:0] + 1;
        end else begin
            // Only roll over if at maximum
            data[3:0] <= 0;
            if (data[7:4] != 4'hF) begin
                data[7:4] <= data[7:4] + 1;
            end else begin
                data[7:4] <= 0;
                if (data[11:8] != 4'hF) begin
                    data[11:8] <= data[11:8] + 1;
                end else begin
                    data[11:8] <= 0;
                    if (data[15:12] != 4'hF) begin
                        data[15:12] <= data[15:12] + 1;
                    end else begin
                        data[15:12] <= 0;
                    end
                end
            end
        end
end else if (PushButtonStates[0] == 1 && LeftPushButtonBuffer == 2'b10) begin
PushButtonStates[0] <= 0;
end
			// RIGHT PUSHBUTTON
			if (PushButtonStates[1] == 0 && RightPushButtonBuffer == 2'b01) begin
				PushButtonStates[1] <= 1;
				// clk_state update
				clk_state <= clk_state + 1;
				if (clk_state > CLK_25) begin
            clk_state <= CLK_15; // return first state
				end   
               
				end else if (PushButtonStates[1] == 1 && RightPushButtonBuffer == 2'b10) begin
				PushButtonStates[1] <= 0;
				end	 
	 

  end

  
  initial begin
    data = 16'hffff;
    RightPushButtonBuffer = 2'b00;
    LeftPushButtonBuffer = 2'b00;
    clk2 = 0;
    PushButtonStates = 2'b11; 
  end
endmodule