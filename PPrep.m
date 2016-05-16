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
      eluteRate;
      options;
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
            if isfield(s.Val,'Text')
              y.(s.Name.Text)=s.Val.Text;
            else
              y.(s.Name.Text)='';
            end
            parsed=parsed+1;
          end
        else
          s=x.String;
          if isfield(s.Val,'Text')
            y.(s.Name.Text)=s.Val.Text;
          else
            y.(s.Name.Text)='';
          end
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
    function obj=PPrep(filename,varargin)
      defaults=struct('ignorepeaks',[]);
      args=processargs(defaults,varargin);
      obj.options=args;
      obj.eluteRate=0.763;   % Relative speed DNA moves through gel when eluting (slower,<1)
      obj.load(filename);
      obj.setuplanes();
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
          %fprintf('Hit %s\n', section');
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
    end

    function analyzepeaks(obj)
      for lane=1:size(obj.IphmA,2)
        y=obj.IphmA(:,lane);
        t=obj.Timers(isfinite(y));	% Remove nans;
        y=y(isfinite(y));
        if length(y)<20
          fprintf('Not enough LED data in lane %d to find peaks\n', lane);
          obj.lane(lane).peaks=[];
        else
          prom=(max(y)-min(y))/20;
          [~,pks]=findpeaks(y,'MinPeakProminence',prom,'MinPeakWidth',5,'MinPeakDistance',20);
          peaktimes=t(pks);
          peaktimes=peaktimes(peaktimes>5*60);	% Skip early peaks
          obj.lane(lane).peaks=peaktimes;
        end
      end
    end

    function t=adjTime(obj,lane,realTime)
    % setup adjusted time/lane
    % adjTime is time in minutes when not eluting
    % but is scaled by eluteScaling when eluting
      t=realTime;
      if isempty(obj.lane(lane).eluteTime)
        return;
      end
      elutesel=t>=obj.lane(lane).eluteTime(1);
      t(elutesel)=t(elutesel)-(t(elutesel)-obj.lane(lane).eluteTime(1))*(1-obj.eluteRate);
      elutesel=realTime>obj.lane(lane).eluteTime(2);
      t(elutesel)=t(elutesel)+(realTime(elutesel)-obj.lane(lane).eluteTime(2))*(1-obj.eluteRate);
    end

    function t=realTime(obj,lane,adjTime)
    % setup adjusted time/lane
    % adjTime is time in minutes when not eluting
    % but is scaled by eluteScaling when eluting
      t=adjTime;
      if isempty(obj.lane(lane).eluteTime)
        return;
      end
      elutesel=t>=obj.lane(lane).eluteTime(1);
      t(elutesel)=t(elutesel)-(t(elutesel)-obj.lane(lane).eluteTime(1))*(1-1/obj.eluteRate);
      elutesel=t>obj.lane(lane).eluteTime(2);
      t(elutesel)=t(elutesel)-(t(elutesel)-obj.lane(lane).eluteTime(2))*(1-obj.eluteRate);
    end

    function sz=timeToSize(obj,lane,mins,atElute)
    % Compute size in nt given mins of propagation
      if nargin<4
        atElute=0;
      end
      if atElute
        map=obj.lane(lane).elutemap;
      else
        map=obj.lane(lane).ledmap;
      end
      sz=interp1(map(:,1),map(:,2),mins,'linear','extrap');
      if any(isnan(sz))
        keyboard
      end
    end
    
    function t=sizeToTime(obj,lane,sz,atElute)
    % Compute size in nt given mins of propagation
      if nargin<4
        atElute=0;
      end
      if atElute
        map=obj.lane(lane).elutemap;
      else
        map=obj.lane(lane).ledmap;
      end
      t=interp1(map(:,2),map(:,1),sz,'linear','extrap');
      if any(isnan(t))
        keyboard
      end
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
      t=obj.Timers/60;
      plot(t,obj.IphmA(:,lane));
      hold on;
      plot(obj.sizeToTime(lane,obj.timeToSize(lane,t),1),obj.IphmA(:,lane));  % At elution
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
      c(4)=max(obj.IphmA(:,lane))*1.2;
      % Mark pause times in red
      pausetimes=obj.Timers(find(obj.PauseFlags))/60;
      for i=1:length(pausetimes)
        plot(pausetimes(i)*[1,1],c(3:4),':r');
      end
      % Mark lane state in green 
      v=(obj.LaneState(:,lane)/2 + 0.1)/1.2 * (c(4)-c(3)) + c(3);
      elutetimes=obj.Timers(obj.LaneState(:,lane)==2)/60;
      h=plot(obj.Timers/60,v,'-g');
      axis(c);
      

      % Mark peaks
      pks=obj.lane(lane).peaks;
      for i=1:length(pks)
        t=pks(i)/60;
        h=text(t,obj.IphmA(pks(i),lane),sprintf('%.1f = %.0f',t,obj.timeToSize(lane,t)));
        set(h,'Rotation',70);
      end
      xlabel('Time (min)');
      ylabel('LED Current (mA)');
      if isfield(obj.lane(lane),'name')
        title(sprintf('Lane %d - %s',lane,obj.lane(lane).name));
      else
        title(sprintf('Lane %d',lane));
      end
      
      % Set time axis so all lanes are the same
      c(2)=max(obj.Timers(any(isfinite(obj.IphmA')))/60);
      axis(c);

      % Plot reference on right axis
      yyaxis right
      plot(c(1):c(2),obj.timeToSize(lane,c(1):c(2)));
      hold on;
      plot(c(1):c(2),obj.timeToSize(lane,c(1):c(2),1));
      ylabel('Size (bp)');
      c=axis;
      c(1)=30;
      c(3:4)=[0,200];
      axis(c);
    end
    
    function ploteluteshift(obj)
    % Plot separation from LED to elute
      setfig('eluteshift');clf;
      sz=20:200;
      for i=1:length(obj.lane)
        tled=obj.sizeToTime(i,sz);
        telute=obj.sizeToTime(i,sz,1);
        plot(sz,telute-tled);
        hold on;
      end
      xlabel('BP');
      ylabel('T(elute)-T(LED) (min)');
    end
        
    function setuplanes(obj)
    % Setup the lanes
      s=obj.Method.Settings;
      obj.lane=[];
      for i=1:length(s.TargetBPs)
        obj.lane=[obj.lane,struct('Name',s.TargetBPs(i).Comm,...
                                  'TargetBPs',rmfield(s.TargetBPs(i),'Comm'),...
                                  'LaneType',s.LaneType(i),...
                                  'SigMon',s.SigMon(i),...
                                  'RefLane',s.RefLane(i))];
      end

      % Check for saturation of LED -- shows up as negative values for Iph
      for i=1:length(obj.lane)
        sat=find(obj.IphmA(:,i)<0);
        nsat=length(sat);
        if nsat>0
          groups=[0,find(diff(sat)>5),nsat];
          for k=2:length(groups)
            max=nanmax(obj.IphmA(:,i));
            satg=sat(groups(k-1)+1:groups(k));
            obj.IphmA(satg,i)=max*(1+0.1*triang(length(satg)));	% Slight ramp up in middle so peak gets centered, plot is clearer
            fprintf('Lane %d LED saturated at %.2f-%.2f min; setting to triangle from %.1f to %.1f\n', i, obj.Timers(satg([1,end]))/60,max,max*1.1);
          end
        end
      end
      
      obj.analyzepeaks();

      % references
      ladderbp=[obj.Cassette.Ladder.BP];
      ladderbp=ladderbp(ladderbp>0);
      fprintf('Ladder for %s is [%s]\n', obj.Cassette.Cass, sprintf('%.1f ',ladderbp));
      for i=1:length(obj.lane)
        l=obj.lane(i);
        ref=l.RefLane;
        if (ref==0)
          fprintf('Lane %d had no reference lane -- skipping it\n', i);
          obj.lane(i).eluteTime=[nan,nan];
          obj.lane(i).pauseTime=nan;
          continue;
        end
        peaks=obj.lane(ref).peaks;
        if ~isempty(obj.options.ignorepeaks)
          sel=setdiff(1:length(peaks),obj.options.ignorepeaks);
          peaks=peaks(sel);
        end
        if length(ladderbp)<length(peaks)
          fprintf('Reference in lane %d has %d lengths, but found %d peaks\n',ref, length(ladderbp),length(peaks));
          keyboard
          return;
        end
        obj.lane(i).eluteTime=obj.Timers([find(obj.LaneState(:,i)==2,1), find(obj.LaneState(:,i)==2,1,'last')])/60;
        if obj.LaneState(end,i)==2
          fprintf('Run stopped at %.2f min before lane %d finished elution\n', obj.Timers(end)/60, i);
          obj.lane(i).eluteTime(2)=nan;
        end
        obj.lane(i).pauseTime=obj.Timers(find(obj.PauseFlags==10^(7-i)))/60;
        if isempty(obj.lane(i).pauseTime)
          obj.lane(i).pauseTime=nan;
        end
        l=obj.lane(i);
        fprintf('Lane %d (%10s), Ref: lane %d, Elute [%3.0f,%3.0f,%3.0f] bps at [%.2f, %.2f, %.2f] min\n', i, l.Name,ref, l.TargetBPs.BPstart,l.TargetBPs.BPpause,l.TargetBPs.BPend,l.eluteTime(1),l.pauseTime,l.eluteTime(2));
        
        % Setup calibration for lane
        % Creates elutemap(:,2) and ledmap(:,2), where map(:,1)=real time in minutes, and map(:,2)=bp
        % These can be then used with interp1 to convert between time and bp at either location
        t=(0:obj.Timers(end))/60;
        at=obj.adjTime(i,t);	% Adjusted time (elapsed time as if it was never eluting)

        lmdl=polyfit(obj.adjTime(ref,peaks/60),ladderbp(1:length(peaks))',2);	% Quadratic fit
        obj.lane(i).lmdl=lmdl;
        obj.lane(i).ledmap=[t;polyval(lmdl,at)]';
        if all(isfinite(l.eluteTime))
          emdl=polyfit(obj.adjTime(i,l.eluteTime(1:2)),[l.TargetBPs.BPstart;l.TargetBPs.BPend],1);	% Linear fit
        elseif isfinite(l.pauseTime)
          emdl=polyfit(obj.adjTime(i,[l.eluteTime(1);l.pauseTime]),[l.TargetBPs.BPstart;l.TargetBPs.BPpause],1);	% Linear fit
        else
          fprintf('Not enough data to model elutions for lane %d\n', i);
        end
        obj.lane(i).emdl=emdl;
        obj.lane(i).elutemap=[t;polyval(emdl,at)]';
      end

      % Display manual pauses
      manualPauses=find(obj.PauseFlags==1);
      if ~isempty(manualPauses)
        fprintf('Manual pauses at [%s] min\n', sprintf('%.2f ',obj.Timers(manualPauses)/60));
      end
    end
    
    function verify(obj)
    % Verify all the computations
      pt=[];   % Computed pause times
      setfig('verify');clf;
      subplot(211);
      allactual=[];allbp=[];allcomp=[];
      for i=1:length(obj.lane)
        l=obj.lane(i);
        if l.RefLane==0
          continue;
        end
        szs=[l.TargetBPs.BPstart,l.TargetBPs.BPpause,l.TargetBPs.BPend];
        actuals=[l.eluteTime(1),l.pauseTime,l.eluteTime(2)];
        et=[];
        for j=1:length(actuals)
          et(j)=obj.sizeToTime(i,szs(j),1);
        end
        err=et-actuals;
        fprintf('Lane %d elute [%3.0f %3.0f %3.0f] @ [%5.2f %5.2f %5.2f] -> computed = [%5.2f %5.2f %5.2f] err=[%5.2f %5.2f %5.2f]\n', i, szs, actuals, et,err);
        plot(actuals,err,'o-');
        allbp=[allbp,szs(1)];
        allactual=[allactual,actuals(1)];
        allcomp=[allcomp,et(1)];
        hold on;
      end
      subplot(212);
      plot(allbp,allactual,'o-');
      hold on;
      plot(allbp,allcomp,'x-');
      legend('Actual','Computed','Location','NorthWest');
      xlabel('Basepairs');
      ylabel('Time (min)');
      title('Elution Start');
    end
  end
end
