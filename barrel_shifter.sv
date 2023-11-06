// Barrel Shifter RTL Model
`include "mux_2x1_behavioral.sv"
module barrel_shifter (
  input logic select,  // select=0 shift operation, select=1 rotate operation
  input logic direction, // direction=0 right move, direction=1 left move
  input logic[1:0] shift_value, // number of bits to be shifted (0, 1, 2 or 3)
  input logic[3:0] din,
  output logic[3:0] dout
);

logic[3:0] in;
logic[3:0] out;
logic[3:0] connection;
logic temp1,temp2,temp3;

always_comb
  begin
    if(select == 1)
      begin
        temp1 = in[0];
        temp2 = in[1];
        temp3 = connection[0];
      end
    else
      begin
        temp1 = 1'b0;
        temp2 = 1'b0;
        temp3 = 1'b0;
      end
  end

always@(din or direction) 
  begin
    if(direction == 0)
      in = din;
    else
      begin
        in[0] = din[3];
        in[1] = din[2];
        in[2] = din[1];
        in[3] = din[0];
      end
  end

  mux_2x1 mux0(.sel(shift_value[1]),.in0(in[0]),.in1(in[2]),.out(connection[0]));
  mux_2x1 mux1(.sel(shift_value[1]),.in0(in[1]),.in1(in[3]),.out(connection[1]));
  mux_2x1 mux2(.sel(shift_value[1]),.in0(in[2]),.in1(temp1),.out(connection[2]));
  mux_2x1 mux3(.sel(shift_value[1]),.in0(in[3]),.in1(temp2),.out(connection[3]));
  mux_2x1 mux4(.sel(shift_value[0]),.in0(connection[0]),.in1(connection[1]),.out(out[0]));
  mux_2x1 mux5(.sel(shift_value[0]),.in0(connection[1]),.in1(connection[2]),.out(out[1]));
  mux_2x1 mux6(.sel(shift_value[0]),.in0(connection[2]),.in1(connection[3]),.out(out[2]));
  mux_2x1 mux7(.sel(shift_value[0]),.in0(connection[3]),.in1(temp3),.out(out[3]));

  always@( out or direction or dout) 
    begin
      if(direction == 0) 
        dout = out;
      else 
        begin
          dout[0] = out[3];
          dout[1] = out[2];
          dout[2] = out[1];
          dout[3] = out[0];
        end
    end

endmodule: barrel_shifter


