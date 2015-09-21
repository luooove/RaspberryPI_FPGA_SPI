module SPI_Slave(clk,rst_n,CS_N,SCK,MOSI,MISO,rxd_data,rxd_flag);
input clk;
input rst_n;
input CS_N;
input SCK;
input MOSI;
//input[7:0] txd_data;
output reg MISO;
output reg[7:0] rxd_data;
output rxd_flag;

wire clk;

reg[7:0] send_data;

//PLL PLL_1(.inclk0(clk_50M),.c0(clk));


/*****************capure the SCK****************/
reg sck_r0,sck_r1;
wire sck_n,sck_p;
always@(posedge clk or negedge rst_n)
begin
	if(!rst_n)
		begin
			sck_r0 <= 1'b1;
			sck_r1 <= 1'b1;
		end
	else
		begin
			sck_r0 <= SCK;
			sck_r1 <= sck_r0;
		end	
end

assign sck_n = (~sck_r0 & sck_r1) ? 1'b1 : 1'b0;
assign sck_p = (~sck_r1 & sck_r0) ? 1'b1 : 1'b0;

/*****************spi_Slave read data****************/
reg rxd_flag_r;
reg [2:0] rxd_state;
reg[7:0] temp;

always@(posedge clk or negedge rst_n)
begin
	if(!rst_n)
		begin
			rxd_data <= 8'b0000_0000;
			rxd_flag_r <= 1'b0;
			rxd_state <= 3'd0;
			temp <= 8'b0000_0000;
		end
	else if(sck_p && !CS_N)
		begin
			case(rxd_state)
				3'd0:
					begin
						rxd_data[7] <= MOSI;
						rxd_flag_r <= 1'b0;
						rxd_state <= 3'd1;
					end
				3'd1:
					begin
						rxd_data[6] <= MOSI;
						rxd_state <= 3'd2;
					end
				3'd2:
					begin
						rxd_data[5] <= MOSI;
						rxd_state <= 3'd3;
					end
				3'd3:
					begin
						rxd_data[4] <= MOSI;
						rxd_state <= 3'd4;
					end
				3'd4:
					begin
						rxd_data[3] <= MOSI;
						rxd_state <= 3'd5;
					end
				3'd5:
					begin
						rxd_data[2] <= MOSI;
						rxd_state <= 3'd6;
					end
				3'd6:
					begin
						rxd_data[1] <= MOSI;
						rxd_state <= 3'd7;
					end
				3'd7:
					begin
						rxd_data[0] <= MOSI;
						//temp <= temp + 1'b1;
						//send_data <= rxd_data;  //把接收到的数据反馈回去
						//send_data[7:0] <= temp[7:0];  //测试
						rxd_flag_r <= 1'b1;
						rxd_state <= 3'd0;
					end
				default:;
			endcase
					
		end	
end

/*****************capure_spi_flag posedge****************/
reg rxd_flag_r0,rxd_flag_r1;
always @(posedge clk or negedge rst_n)
begin
	if(!rst_n)
		begin
			rxd_flag_r0 <= 1'b0;
			rxd_flag_r1 <= 1'b0;
		end
	else
		begin
			rxd_flag_r0 <= rxd_flag_r;
			rxd_flag_r1 <= rxd_flag_r0;
		end
end

assign rxd_flag = (~rxd_flag_r1 & rxd_flag_r0) ? 1'b1 : 1'b0;



always@(posedge rxd_flag_r)
begin
	send_data <= rxd_data;  //把接收到的数据反馈回去
end


/*****************spi_Slaver send data****************/

reg[3:0] txd_state;

always@(posedge clk or negedge rst_n)
begin
	if(!rst_n)
		begin
			txd_state <= 1'b0;
			//send_data <= 8'h01;
		end
	else if(sck_n && !CS_N)
		begin
			case(txd_state)
				4'd0:
					begin
						MISO <= send_data[7];
						txd_state <= 3'd1;
					end
				4'd1:
					begin
						MISO <= send_data[6];
						txd_state <= 3'd2;
					end
				4'd2:
					begin
						MISO <= send_data[5];
						txd_state <= 3'd3;
					end
				4'd3:
					begin
						MISO <= send_data[4];
						txd_state <= 3'd4;
					end
				4'd4:
					begin
						MISO <= send_data[3];
						txd_state <= 3'd5;
					end
				4'd5:
					begin
						MISO <= send_data[2];
						txd_state <= 3'd6;
					end
				4'd6:
					begin
						MISO <= send_data[1];
						txd_state <= 3'd7;
					end
				4'd7:
					begin
						MISO = send_data[0];
						//send_data = send_data + 1'b1;
						txd_state = 3'd0;
					end
				//4'd8:
				//	begin
				//		send_data = send_data + 1'b1;
				//		txd_state = 3'd0;
				//	end
				default:;
			endcase
		end
end

endmodule
