`timescale 1ps / 1ps
module CIRCLE_tb();
    reg clk, rst;
    
    CIRCLE Circle(clk, rst);

    integer foutput;
    integer counter = 0;

    initial begin
        $readmemh("test.dat", Circle.InsMem.ROM);
        foutput = $fopen("results.txt");
        clk = 1;
        rst = 1;
        #5 rst = 0;
        #10 rst = 1;
        #15 rst = 0;
        //#20 rst = 1;
        //#25 rst = 0;
        //$display($time, "clk: %h", clk);
    end
    

        always begin
            #25 clk = ~clk;
            if ((Circle.ins == 32'hxxxxxxxx)) $finish;
            if (clk) begin
                /*
                $fdisplay(foutput, "clk: %h", clk);
                //$display("ins: %h", Circle.ins);
                //$display("nextins: %h", Circle.InsMem.ROM[Circle.Cpu.npc[8:2]]);
                $fdisplay(foutput, "rst: %h", rst);
                //$fclose(foutput);
                $fdisplay(foutput, "Type: %h %h %h %h %h %h %h %h %h", Circle.Cpu.Ctrl.rtype, Circle.Cpu.Ctrl.ritype, Circle.Cpu.Ctrl.loadtype, Circle.Cpu.Ctrl.stype, Circle.Cpu.Ctrl.sbtype, Circle.Cpu.Ctrl.jalrtype, Circle.Cpu.Ctrl.jaltype, Circle.Cpu.Ctrl.auipctype, Circle.Cpu.Ctrl.luitype);
                $fdisplay(foutput, "rs1: %h", Circle.Cpu.RegFile.rs1);
                $fdisplay(foutput, "rs2: %h", Circle.Cpu.RegFile.rs2);
                $fdisplay(foutput, "rd: %h", Circle.Cpu.RegFile.rd);
                $fdisplay(foutput, "pc:\t %h", Circle.pc);
                $fdisplay(foutput, "ins:\t %h", Circle.ins);
                $fdisplay(foutput, "pcsrc:\t %h", Circle.Cpu.pcsrc);
                $fdisplay(foutput, "aludatain1:\t %h", Circle.Cpu.aludatain1);
                $fdisplay(foutput, "aludatain2:\t %h", Circle.Cpu.aludatain2);
                $fdisplay(foutput, "InsMem:\t %h %h", Circle.InsMem.ROM[0], Circle.InsMem.ROM[Circle.Cpu.Npc.npc[8:2]]);
                $fdisplay(foutput, "Alusrc:\t %h %h", Circle.Cpu.Ctrl.alusrc1, Circle.Cpu.alusrc2);
                $fdisplay(foutput, "Aluop:\t %h", Circle.Cpu.Ctrl.aluop);
                $fdisplay(foutput, "aluzero:\t %h", Circle.Cpu.Alu.aluzero);
                $fdisplay(foutput, "Pcsrc:\t %h", Circle.Cpu.Ctrl.pcsrc);
                $fdisplay(foutput, "NPC:\t %h", Circle.Cpu.Npc.npc);
                $fdisplay(foutput, "PC:\t %h", Circle.Cpu.Pc.pc);
                $fdisplay(foutput, "ALUAns:\t %h", Circle.Cpu.Alu.aludataout);
                $fdisplay(foutput, "MemAddr:\t %h", Circle.DataMem.memaddr);
                $fdisplay(foutput, "MemOp:\t %h", Circle.DataMem.memop);
                $fdisplay(foutput, "memop:\t %h", (8 << Circle.DataMem.memop) - 1);
                $fdisplay(foutput, "MemAns:\t %h", Circle.DataMem.ROM[Circle.DataMem.memaddr]);
                $fdisplay(foutput, "MemOut:\t %h", Circle.DataMem.memdataout);
                $fdisplay(foutput, "MuxReg:\t %h", Circle.Cpu.MuxReg.regdata);
                */
                
                $fdisplay(foutput, "regf00-03:\t %h %h %h %h", Circle.Cpu.RegFile.regf[0], Circle.Cpu.RegFile.regf[1], Circle.Cpu.RegFile.regf[2], Circle.Cpu.RegFile.regf[3]);
                $fdisplay(foutput, "regf04-07:\t %h %h %h %h", Circle.Cpu.RegFile.regf[4], Circle.Cpu.RegFile.regf[5], Circle.Cpu.RegFile.regf[6], Circle.Cpu.RegFile.regf[7]);
                $fdisplay(foutput, "regf08-11:\t %h %h %h %h", Circle.Cpu.RegFile.regf[8], Circle.Cpu.RegFile.regf[9], Circle.Cpu.RegFile.regf[10], Circle.Cpu.RegFile.regf[11]);
                $fdisplay(foutput, "regf12-15:\t %h %h %h %h", Circle.Cpu.RegFile.regf[12], Circle.Cpu.RegFile.regf[13], Circle.Cpu.RegFile.regf[14], Circle.Cpu.RegFile.regf[15]);
                $fdisplay(foutput, "regf16-19:\t %h %h %h %h", Circle.Cpu.RegFile.regf[16], Circle.Cpu.RegFile.regf[17], Circle.Cpu.RegFile.regf[18], Circle.Cpu.RegFile.regf[19]);
                $fdisplay(foutput, "regf20-23:\t %h %h %h %h", Circle.Cpu.RegFile.regf[20], Circle.Cpu.RegFile.regf[21], Circle.Cpu.RegFile.regf[22], Circle.Cpu.RegFile.regf[23]);
                $fdisplay(foutput, "regf24-27:\t %h %h %h %h", Circle.Cpu.RegFile.regf[24], Circle.Cpu.RegFile.regf[25], Circle.Cpu.RegFile.regf[26], Circle.Cpu.RegFile.regf[27]);
                $fdisplay(foutput, "regf28-31:\t %h %h %h %h", Circle.Cpu.RegFile.regf[28], Circle.Cpu.RegFile.regf[29], Circle.Cpu.RegFile.regf[30], Circle.Cpu.RegFile.regf[31]);
                $fdisplay(foutput, "datamem00:\t %h %h %h %h", Circle.DataMem.ROM[3], Circle.DataMem.ROM[2], Circle.DataMem.ROM[1], Circle.DataMem.ROM[0]);
                $fdisplay(foutput, "datamem04:\t %h %h %h %h", Circle.DataMem.ROM[7], Circle.DataMem.ROM[6], Circle.DataMem.ROM[5], Circle.DataMem.ROM[4]);
                $fdisplay(foutput, "datamem08:\t %h %h %h %h", Circle.DataMem.ROM[11], Circle.DataMem.ROM[10], Circle.DataMem.ROM[9], Circle.DataMem.ROM[8]);
                
                //$fdisplay(foutput, "regf04-07:\t %h", Circle.Cpu.RegFile.regf[7]);
            end
        end
    initial
    begin
        $dumpfile("CIRCLE_tb.vcd");
        $dumpvars(0, CIRCLE_tb);
    end
endmodule