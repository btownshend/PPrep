classdef PPrep < handle
  properties
      Timers;
      HiVoltV;
      TdegC;
      Flags;
      LaneState;
      LEDState;
      IphmA;
      IlanemA;
      PauseFlags;
      Date;
      lane;
      Cassette;
      Config;
      LEDs
      Method;
      ProtName;
      Settings;
      Timestamp;
      Versions;
  end

  methods(Static)
    function y=xmlArray(x)
      nm=x.Name.Text;
      if iscell(x.Dimsize)
        dimsize=[];
        for i=1:length(x.Dimsize)
          dimsize(i)=str2double(x.Dimsize{i}.Text);
        end
      else
        dimsize=str2double(x.Dimsize.Text);
      end
      if isfield(x,'Cluster')
        % Array of clusters (structs)
        assert(length(x.Cluster)==prod(dimsize));
        y=[];
        for i=1:length(x.Cluster)
          y=[y,PPrep.xmlCluster(x.Cluster{i})];
        end
      elseif isfield(x,'DBL')
        assert(length(x.DBL)==prod(dimsize));
        y=[];
        for i=1:length(x.DBL)
          y=[y,str2double(x.DBL{i}.Val.Text)];
        end
      elseif isfield(x,'I32')
        assert(length(x.I32)==prod(dimsize));
        y=[];
        for i=1:length(x.I32)
          y=[y,str2double(x.I32{i}.Val.Text)];
        end
      elseif isfield(x,'U16')
        assert(length(x.U16)==prod(dimsize));
        y=[];
        for i=1:length(x.U16)
          y=[y,str2double(x.U16{i}.Val.Text)];
        end
      elseif isfield(x,'Boolean')
        assert(length(x.Boolean)==prod(dimsize));
        y=[];
        for i=1:length(x.Boolean)
          y=[y,str2double(x.Boolean{i}.Val.Text)~=0];
        end
      elseif isfield(x,'EL')
        assert(length(x.EL)==prod(dimsize));
        y={};
        for i=1:length(x.EL)
          y{i}=x.EL{i}.Choice{str2double(x.EL{i}.Val.Text)}.Text;
        end
      elseif isfield(x,'EW')
        assert(length(x.EW)==prod(dimsize));
        y={};
        for i=1:length(x.EW)
          y{i}=x.EW{i}.Choice{str2double(x.EW{i}.Val.Text)}.Text;
        end
      else
        assert(false);
      end
      if length(dimsize)>1
        assert(prod(dimsize)==length(y));
        y=reshape(y,dimsize);
      end
    end
    
    function y=xmlCluster(x)
      y=struct();
      nm=x.Name.Text;
      numelts=str2double(x.NumElts.Text);
      parsed=0;
      if isfield(x,'String')
        if iscell(x.String)
          for i=1:length(x.String)
            s=x.String{i};
            y.(s.Name.Text)=s.Val.Text;
            parsed=parsed+1;
          end
        else
          s=x.String;
          y.(s.Name.Text)=s.Val.Text;
          parsed=parsed+1;
        end
      end
      if isfield(x,'SGL')
        if iscell(x.SGL)
          for i=1:length(x.SGL)
            s=x.SGL{i};
            y.(s.Name.Text)=s.Val.Text;
            parsed=parsed+1;
          end
        else
          s=x.SGL;
          y.(s.Name.Text)=s.Val.Text;
          parsed=parsed+1;
        end
      end
      if isfield(x,'DBL')
        if iscell(x.DBL)
          for i=1:length(x.DBL)
            s=x.DBL{i};
            y.(s.Name.Text)=str2double(s.Val.Text);
            parsed=parsed+1;
          end
        else
          s=x.DBL;
          y.(s.Name.Text)=str2double(s.Val.Text);
          parsed=parsed+1;
        end
      end
      if isfield(x,'I32')
        if iscell(x.I32)
          for i=1:length(x.I32)
            s=x.I32{i};
            y.(s.Name.Text)=str2double(s.Val.Text);
            parsed=parsed+1;
          end
        else
          s=x.I32;
          y.(s.Name.Text)=str2double(s.Val.Text);
          parsed=parsed+1;
        end
      end
      if isfield(x,'U32')
        if iscell(x.U32)
          for i=1:length(x.U32)
            s=x.U32{i};
            y.(s.Name.Text)=str2double(s.Val.Text);
            parsed=parsed+1;
          end
        else
          s=x.U32;
          y.(s.Name.Text)=str2double(s.Val.Text);
          parsed=parsed+1;
        end
      end
      if isfield(x,'U16')
        if iscell(x.U16)
          for i=1:length(x.U16)
            s=x.U16{i};
            y.(s.Name.Text)=str2double(s.Val.Text);
            parsed=parsed+1;
          end
        else
          s=x.U16;
          y.(s.Name.Text)=str2double(s.Val.Text);
          parsed=parsed+1;
        end
      end
      if isfield(x,'Boolean')
        if iscell(x.Boolean)
          for i=1:length(x.Boolean)
            s=x.Boolean{i};
            y.(s.Name.Text)=str2double(s.Val.Text)~=0;
            parsed=parsed+1;
          end
        else
          s=x.Boolean;
          y.(s.Name.Text)=str2double(s.Val.Text)~=0;
          parsed=parsed+1;
        end
      end
      if isfield(x,'EW')
        if iscell(x.EW)
          for i=1:length(x.EW)
            s=x.EW{i};
            y.(s.Name.Text)=s.Choice{str2double(s.Val.Text)}.Text;
            parsed=parsed+1;
          end
        else
          s=x.EW;
          y.(s.Name.Text)=s.Choice{str2double(s.Val.Text)}.Text;
          parsed=parsed+1;
        end
      end
      if isfield(x,'Cluster')
        if iscell(x.Cluster)
          for i=1:length(x.Cluster)
            s=x.Cluster{i};
            y.(s.Name.Text)=PPrep.xmlCluster(s);
            parsed=parsed+1;
          end
        else
          s=x.Cluster;
          y.(s.Name.Text)=PPrep.xmlCluster(s);
          parsed=parsed+1;
        end
      end
      if isfield(x,'Array')
        if iscell(x.Array)
          for i=1:length(x.Array)
            s=x.Array{i};
            y.(s.Name.Text)=PPrep.xmlArray(s);
            parsed=parsed+1;
          end
        else
          s=x.Array;
          y.(s.Name.Text)=PPrep.xmlArray(s);
          parsed=parsed+1;
        end
      end
      assert(parsed==numelts);
    end
  end

  methods
    function obj=PPrep(filename)
      obj.load(filename);
      obj.analyzepeaks();
      obj.setuprefs();
    end
    
    
    function xml=getSection(obj,sectionData)
      if sectionData(1)=='<'
        % XML
        tmpfile=tempname();
        fd=fopen(tmpfile,'w');
        fprintf(fd,'%s',sectionData);
        fclose(fd);
        s=xml2struct(tmpfile);
        if isfield(s,'Cluster')
          xml=obj.xmlCluster(s.Cluster);
        elseif isfield(s,'Array')
          xml=obj.xmlArray(s.Array);
        elseif isfield(s,'String')
          xml=s.String.Val.Text;
        else
          assert(false);
        end
        
        delete(tmpfile);
      else
        % Literal
        xml=sectionData;
      end
    end
    
    function parseMethod(obj)
      s=obj.Method.Settings;
      obj.lane=[];
      for i=1:length(s.TargetBPs)
        obj.lane=[obj.lane,struct('TargetBPs',s.TargetBPs(i),...
                                  'LaneType',s.LaneType(i),...
                                  'SigMon',s.SigMon(i),...
                                  'RefLane',s.RefLane(i))];
      end
    end
      
    function load(obj, filename)
      fileID = fopen(filename,'r');
      % Skip ahead to data array
      inSection=[];
      secdata=[];
      while true
        line=fgetl(fileID);
        if line==-1
          error('%s: hit EOF while scanning for LEDsEnd\n',filename);
        end
        if strncmp(line,'***',3)
          section=line(4:end-3);
          fprintf('Hit %s\n', section');
          if strcmp(section(end-4:end),'Start')
            assert(isempty(inSection));
            inSection=section(1:end-5);
          elseif strcmp(section(end-2:end),'End')
            obj.(inSection)=obj.getSection(secdata);
            assert(~isempty(inSection));
            inSection=[];
            secdata=[];
          else
            fprintf('Bad section marker: %s\n', section);
          end
        elseif ~isempty(inSection)
          if ~isempty(line)
            secdata=sprintf('%s%s\n',secdata,line);
          end
        end
        if strcmp(line,'***LEDsEnd***')
          fgetl(fileID);   % Skip blank line
          break;
        end
      end
      formatSpec = '%f%f%q%f%f%f%f%f%f%f%f%f%f%f%f%f%f%{dd-MMM-yyyy}D%{HH:mm:ss}D%[^\n\r]';
      dataArray = textscan(fileID, formatSpec, 'Delimiter', '\t', 'EmptyValue' ,NaN,'HeaderLines', 1, 'ReturnOnError', false);
      fclose(fileID);
      obj.Timers = dataArray{:, 1};
      obj.HiVoltV = dataArray{:, 2};
      obj.TdegC = dataArray{:, 3};
      obj.Flags = dataArray{:, 4};
      obj.LaneState = cell2mat(arrayfun(@(z) sprintf('%05d',z),dataArray{:, 5},'UniformOutput',false))-'0';
      obj.LEDState = dataArray{:, 6};
      obj.IphmA = cell2mat(dataArray(:, 7:11));
      obj.IlanemA = cell2mat(dataArray(:, 12:16));
      obj.PauseFlags = dataArray{:, 17};
      obj.Date = datenum(dataArray{:, 18})+datenum(dataArray{:, 19});

      % Setup lanes structure from method in file
      obj.parseMethod()
    end

    function analyzepeaks(obj)
      for lane=1:size(obj.IphmA,2)
        y=obj.IphmA(:,lane);
        t=obj.Timers(isfinite(y));	% Remove nans;
        y=y(isfinite(y));
        prom=(max(y)-min(y))/20;
        [~,pks]=findpeaks(y,'MinPeakProminence',prom,'MinPeakWidth',5);
        peaktimes=t(pks);
        peaktimes=peaktimes(peaktimes>5*60);	% Skip early peaks
        obj.lane(lane).peaks=peaktimes;
      end
    end

    function setuprefs(obj)
      ladderbp=[obj.Cassette.Ladder.BP];
      ladderbp=ladderbp(ladderbp>0);
      fprintf('Ladder for %s is [%s]\n', obj.Cassette.Cass, sprintf('%.1f ',ladderbp));
      for i=1:length(obj.lane)
        ref=obj.lane(i).RefLane;
        if length(ladderbp)<length(obj.lane(ref).peaks)
          fprintf('Reference has %d lengths, but found %d peaks\n',length(ladderbp),length(obj.lane(ref).peaks));
          keyboard
          return;
        end
        obj.lane(i).mdl=struct('timeLEDBP',polyfit(obj.lane(ref).peaks/60,ladderbp(1:length(obj.lane(ref).peaks))',1));
      end
    end
    
    function sz=timeToSize(obj,lane,mins)
    % Compute size in nt given mins of propagation
    %      sz=interp1(obj.lane{lane}.mdl(:,1),obj.lane{lane}.mdl(:,2),mins,'linear','extrap');
      sz=exp(interp1(1./obj.lane{lane}.mdl(:,1),log(obj.lane{lane}.mdl(:,2)),1./mins,'linear','extrap'));
    end
    
    function mins=sizeToTime(obj,lane,sz)
    % Compute size in nt given mins of propagation
    %mins=interp1(obj.lane{lane}.mdl(:,2),obj.lane{lane}.mdl(:,1),sz,'linear','extrap');
      mins=1./interp1(log(obj.lane{lane}.mdl(:,2)),1./obj.lane{lane}.mdl(:,1),log(sz),'linear','extrap');
    end
    
    % function plotref(obj)
    %   plot(obj.Timers(obj.reflocs)/60,obj.refsizes,'o');
    %   hold on;
    %   c=axis;
    %   t=c(1):c(2);
    %   plot(t,obj.timeToSize(t),':');
    %   xlabel('Time (min)');
    %   ylabel('Size (nt)');
    %   title('References');
    % end
    
    function plotall(obj)
      setfig('PPrep');clf;
      for i=1:5
        subplot(3,2,i);
        obj.plot(i);
      end
      %subplot(3,2,6);
      %obj.plotref();
    end
    
      
    function plot(obj,lane)
      yyaxis left
      plot(obj.Timers/60,obj.IphmA(:,lane));
      hold on;
      c=axis;
      if false
        mid=mean(c(3:4));
        changes=find(diff(obj.LaneState(:,lane))~=0);
        offset=3.5;
        for i=1:length(changes)
          plot(obj.Timers(changes(i))/60*[1,1]-offset,[c(3),mid],':k');
          plot(obj.Timers(changes(i))/60*[1,1],[mid,c(4)],':k');
        end
      end
      c=axis;
      % Mark pause times in red
      pausetimes=obj.Timers(find(obj.PauseFlags))/60;
      for i=1:length(pausetimes)
        plot(pausetimes(i)*[1,1],c(3:4),':r');
      end
      % Mark lane state in green 
      v=(obj.LaneState(:,lane)/2 + 0.1)/1.2 * (c(4)-c(3)) + c(3);
      elutetimes=obj.Timers(obj.LaneState(:,lane)==2)/60;
      h=plot(obj.Timers/60,v,':g');
      

      % Mark peaks
      pks=obj.peaks{lane};
      for i=1:length(pks)
        t=pks(i)/60;
        h=text(t,obj.IphmA(pks(i),lane),sprintf('%.1f = %.0f',t,obj.timeToSize(lane,t)));
        set(h,'Rotation',70);
      end
      xlabel('Time (min)');
      ylabel('LED Current (mA)');
      if isfield(obj.lane{lane},'name')
        title(sprintf('Lane %d - %s',lane,obj.lane{lane}.name));
      else
        title(sprintf('Lane %d',lane));
      end
      
      % Set time axis so all lanes are the same
      c(2)=max(obj.Timers(any(isfinite(obj.IphmA')))/60);
      c(4)=c(4)+(c(4)-c(3));
      axis(c);

      % Plot reference on right axis
      yyaxis right
      plot(c(1):c(2),obj.timeToSize(lane,c(1):c(2)));
      hold on;
      ylabel('Size (bp)');
      c=axis;
      c(3:4)=[0,200];
      axis(c);

      % Mark planned elution points in red
      if isfield(obj.lane{lane},'bandbps')
        bandbps=obj.lane{lane}.bandbps;
        bandtime=obj.sizeToTime(lane,bandbps);
        for i=1:length(bandbps)
          plot(bandtime(i)*[1,1],[0,bandbps(i)],':r');
          h=plot([bandtime(i),c(2)],bandbps(i)*[1,1],':r');
        end
        legend(h,sprintf('Elute %d-%d',bandbps),'Location','NorthWest');
      end
    end
    
    function setupLane(obj,lane,name,reflane,low,high)
      s=struct('name',name,'reflane',reflane,'elute',obj.Timers([find(obj.LaneState(:,lane)==2,1), find(obj.LaneState(:,lane)==2,1,'last')])/60,'bandbps',[low,high]);
      fprintf('Setup lane %d to use reference lane %d, range bps=[%d,%d], elute=%.2f:%.2f min\n', lane, s.reflane, s.bandbps,s.elute);
      % Setup piecewise linear model that maps time (x) to bp (y)
      s.mdl=obj.lane{reflane}.mdl; 	% Initialize with reference model
      s.mdl(end+1,:)=[obj.sizeToTime(reflane,low),low];
      s.mdl(end+1,:)=[(s.elute(2)-s.elute(1))+s.mdl(end,1),high];	  % Elution
      obj.lane{lane}=s;
    end
  end
end
