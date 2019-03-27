classdef (Abstract) OpticalComponent < matlab.mixin.Heterogeneous & handle
    %OPTICALCOMPONENT Summary of this class goes here
    %   Detailed explanation goes here
    
    properties
        mat
        mat_sym
        hid_sym
        hid_sol
        thick
        ordernum
        long logical
    end
    
    properties(Abstract)
        hid double
    end
    
    methods
        function mat=getMat(obj)
            mat=obj.mat;            
        end
        
        function matsym=getMatSym(obj)
             matsym=obj.mat_sym;  
        end
        
        function AssignOrderNum(obj,ordernum)
            obj.ordernum=ordernum;
            obj.GenSym();          
        end
               
        function sol=GetSolution(obj,syms,vals)
            sol=obj.hid_sol;
            for i=1:length(vals)
                sol=subs(sol,syms(i),vals(i));
            end
        end
         
        function ApplySolution(obj,syms,vals)
            obj.hid=double(GetSolution(obj,syms,vals));
            if length(obj.hid) > 1
                disp(['I fucked up: ',char(obj.hid_sym)])
            end
        end
        
        function [trace vek]=Propagate(obj,trace,vek) 
            vek=obj.mat*vek;
            if obj.thick > 0
            newpos=[trace(end,1)+obj.thick,vek(1)];
            trace=cat(1,trace,newpos);
            end 
        end
        
    end
    
     methods(Abstract)
         GenSym(obj)
     end
    
end

