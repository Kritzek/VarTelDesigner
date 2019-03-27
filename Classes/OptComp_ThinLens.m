classdef OptComp_ThinLens < OpticalComponent
    %OPTCOMP_LENS Summary of this class goes here
    %   Detailed explanation goes here
    
    properties
        hid double
    end
    
    methods
        function obj=OptComp_ThinLens(FocalLength);
            obj.hid=FocalLength;
            obj.thick=0;
            obj.long=0;
        end
        
        function set.hid(obj,hid)
            obj.hid=hid;
            obj.mat=[1,0;-1/hid,1];
        end
        
        function GenSym(obj)
            obj.hid_sym=sym(['F',num2str(obj.ordernum)]);
            obj.mat_sym=[1,0;-1/obj.hid_sym,1];
        end
        
        
        function valid=CheckValid(obj,arr)
            %Invalid focal length???
            valid=ones(1,length(arr));
        end
        
        
        
        
    end
    
end

