// COMPE470L Lab 3 - Seven Segment Display Counter
// Counts HEX: F -> 0 -> F -> ...
// Basys 3 7-seg is common-anode: anodes active-LOW, segments active-LOW

module Lab3_HexDownCounter (
    input  wire       clock_100Mhz,
    input  wire       reset,
    output reg  [3:0] Anode_Activate,
    output reg  [6:0] LED_out
);

    // 1 second tick generator (100 MHz clock)
    reg [26:0] one_second_counter;
    wire one_second_tick;

    always @(posedge clock_100Mhz or posedge reset) begin
        if (reset)
            one_second_counter <= 27'd0;
        else if (one_second_counter == 27'd99_999_999)
            one_second_counter <= 27'd0;
        else
            one_second_counter <= one_second_counter + 1'b1;
    end

    assign one_second_tick = (one_second_counter == 27'd99_999_999);

    // HEX value (4-bit) to display: start at F, count down to 0, wrap to F
    reg [3:0] hex_val;

    always @(posedge clock_100Mhz or posedge reset) begin
        if (reset)
            hex_val <= 4'hF;
        else if (one_second_tick) begin
            if (hex_val == 4'h0)
                hex_val <= 4'hF;
            else
                hex_val <= hex_val - 1'b1;
        end
    end

    // Enable only the rightmost digit (AN0). Others OFF.
    // Basys 3 anodes are active-LOW.
    always @(*) begin
        Anode_Activate = 4'b1110;  // AN0 ON
    end

    // HEX to 7-seg (active-LOW segments for Basys 3)
    always @(*) begin
        case (hex_val)
            4'h0: LED_out = 7'b0000001; // 0
            4'h1: LED_out = 7'b1001111; // 1
            4'h2: LED_out = 7'b0010010; // 2
            4'h3: LED_out = 7'b0000110; // 3
            4'h4: LED_out = 7'b1001100; // 4
            4'h5: LED_out = 7'b0100100; // 5
            4'h6: LED_out = 7'b0100000; // 6
            4'h7: LED_out = 7'b0001111; // 7
            4'h8: LED_out = 7'b0000000; // 8
            4'h9: LED_out = 7'b0000100; // 9
            4'hA: LED_out = 7'b0001000; // A
            4'hB: LED_out = 7'b1100000; // b
            4'hC: LED_out = 7'b0110001; // C
            4'hD: LED_out = 7'b1000010; // d
            4'hE: LED_out = 7'b0110000; // E
            4'hF: LED_out = 7'b0111000; // F
            default: LED_out = 7'b0000001; // 0
        endcase
    end

endmodule
