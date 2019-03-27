classdef OpticalSetup < handle
    %OPTICALSETUP Summary of this class goes here
    %   Detailed explanation goes here
    
    properties
        complist
        sysmat
        sysmat_sym
        sol
        solinds %indices for which drifts solutions shall apply
        finds %complement to solinds
        mag
        length
        magrat
        magmin
        magmax
    end
    
    methods
        function AddComp(obj,comp,varargin)
            comp.AssignOrderNum(length(obj.complist)+1);
            obj.complist=cat(1,obj.complist,comp);
        end
        
        function sysmat=CalcSysMat(obj)
            obj.sysmat=eye(2)
            for i=1:length(obj.complist)
                obj.sysmat=obj.sysmat*obj.complist(i).getMat();
            end
            sysmat=obj.sysmat;
        end
        
        function sysmat=CalcSysMatSym(obj)
            obj.sysmat_sym=eye(2);
            ncomps=length(obj.complist);
            for i=1:ncomps
                obj.sysmat_sym=obj.sysmat_sym*obj.complist(ncomps+1-i).getMatSym();
            end
            sysmat=obj.sysmat_sym;
        end
        
        function [pos amp] =GetTrace(obj,svek)
            svek=rot90(svek,3);
            trace=[0,svek(1)];
            for i=1:length(obj.complist)
                [trace svek]=obj.complist(i).Propagate(trace,svek);
            end
            pos=trace(:,1);
            amp=trace(:,2);
        end
        
        function [dsyms inds] = GetLongSyms(obj,lflag)
             inds=arrayfun(@(x) x.long ,obj.complist);
             inds= inds == lflag;
             inds=find(inds);           
             dsyms=[obj.complist(inds).hid_sym];           
        end
        
        
        
        
        function Solve2Image(obj,solinds) 
            
             M=sym('M');
             L=sym('L');  
             smat=obj.CalcSysMatSym();
             eq(1) = M ==  smat(1,1);
             eq(2)= 0 == smat(1,2);
             eq(3)= 0 == smat(2,1);
             [dsyms inds] = obj.GetLongSyms(1);
             eq(4)= L == sum(dsyms);
             
             comsym=[obj.complist(:).hid_sym];
             if length(solinds) ~= 4
                 disp('Choose 4 parameters to solve for');
                 return
             end                 
%              try 
             solsyms=comsym(solinds);
             obj.solinds=solinds;
             ndr=1:length(comsym);
             ndr(solinds)=0;
             obj.finds=find(ndr);
%              catch
%                  disp('Could not apply indizes to vector parameters');
%                  return
%              end
             
             sol=struct2cell(solve(eq,solsyms));
             nsol=length(sol{1});
             solops=linspace(1,nsol,nsol);
             solops=arrayfun(@(x) num2str(x),solops,'UniformOutput',0);
             
             if nsol > 1
                 prefs=uigetpref('MultipleSolution','MultipleSolution1', ...
                     'Choose Solution',...
                     ['The system appears to have ', num2str(nsol),...
                     ' solutions. Choose which one to use.'],solops);
                 soli=str2num(prefs);
             else
                 soli=1;
             end
                     
             
             
             %Distribute solutions to member objects 
             for i=1:length(solinds)
                 asol=sol{i};
                 asol=asol(soli);
                 obj.complist(solinds(i)).hid_sol=asol;
             end
        end
        
        function ApplyDrifts(obj,Mag,Length)
              obj.mag=Mag;
              obj.length=Length;
              M=sym('M');
              L=sym('L');
              comsyms=[obj.complist(:).hid_sym];
              comvals=[obj.complist(:).hid];  
              vals=[Mag,Length,comvals(obj.finds)];             
              syms=[M,L,comsyms(obj.finds)];                                        
              for i=1:length(obj.solinds)
                 obj.complist(obj.solinds(i)).ApplySolution(syms,vals);
              end                                    
        end
        
        function [dout valid]=GetDrifts(obj,Mag,Length)
              M=sym('M');
              L=sym('L');
              comsym=[obj.complist(:).hid_sym];
              comvals=[obj.complist(:).hid];
              vals=comvals(obj.finds);             
              syms=comsym(obj.finds); 

              dout=[];
              valids=[];
              for i=1:length(obj.solinds)
                  dtemp=obj.complist(obj.solinds(i)).GetSolution(syms,vals);
                  dtemp=subs(dtemp,L,Length);
                  dtemp=double(subs(dtemp,M,Mag));
                  %All Symbols should be substituted  now
                  %otherwise the double function will fail (use a try?)
                  val=obj.complist(obj.solinds(i)).CheckValid(dtemp);
                  dout=cat(1,dout, dtemp);
                  valids=cat(1,valids, val);
              end 
              [nd vl ]= size(dout);
              valid=(sum(valids,1) == nd);
              mini=min(find(valid &(Mag>-1)));
              maxi=max(find(valid));
%               if maxi==vl
%                   obj.magrat=NaN;
%               else
              obj.magmin=-1/Mag(mini);
              obj.magmax=-1/Mag(maxi);
              
              obj.magrat=obj.magmax./obj.magmin;
%               end
              
        end
        
        
        function status=GetStatusText(obj)
            
            l0=['Magnification: ',num2str(-1/obj.mag), char(10), ...
                'Length: ', num2str(obj.length), char(10),...
                'Min Mag: ', num2str(obj.magmin), char(10),...
                'Max Mag: ', num2str(obj.magmax), char(10),...
                'Mag Ratio: ', num2str(obj.magrat), char(10)];
            
            l1=[char(10),'Lenses:',char(10)];
            [focsyms s_locs] = obj.GetLongSyms(0);
            lensstat='';
            for i=1:length(s_locs)
                apos=sum([obj.complist(1:s_locs(i)).thick]);
                lensstat=[lensstat,char(focsyms(i)),': ',...
                num2str(obj.complist(s_locs(i)).hid),...
                ' at pos ', num2str(apos),char(10)];
            end

%             l2=[char(10),'Drifts:',char(10)];
%             [distsyms d_locs] =obj.GetLongSyms(1);
%             dstat='';
%             for i=1:length(d_locs)
%             dstat=[dstat,char(distsyms(i)),': ',...
%                 num2str(obj.complist(d_locs(i)).hid),'   to abs   ' ...
%                 num2str(sum([obj.complist(d_locs(1:i)).hid])),char(10)];
%             end
            status=[l0,l1,lensstat];%l2,dstat];
        end
            
    end
    
end

