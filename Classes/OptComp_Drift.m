classdef OptComp_Drift < OpticalComponent
    %OPTCOMP_DRIFT Summary of this class goes here
    %   Detailed explanation goes here
    
    properties
        hid double
    end
    
    methods
        function obj=OptComp_Drift(DriftLength)
            obj.hid=DriftLength;
            obj.thick=DriftLength;
            obj.long=1;
        end
        
        function set.hid(obj,hid)
            obj.hid=hid;
            obj.thick=hid;
            obj.mat=[1,hid;0,1];
        end
        
        function GenSym(obj)
            obj.hid_sym=sym(['D',num2str(obj.ordernum)]);
            obj.mat_sym=[1,obj.hid_sym;0,1];
        end
        
        
        function valid=CheckValid(obj,arr)
            %Invalid if drifts are negative???
            valid=arr > 0;
        end
        
    end
    
end

