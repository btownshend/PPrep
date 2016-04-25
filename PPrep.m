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
      eluteScale;
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
      obj.eluteRate=0.7450;   % Relative speed DNA moves through gel when eluting (slower,<1)
      obj.eluteScale=0.9289;     % At time t*eluteScale, the DNA currently at elution was at the LED
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
        prom=(max(y)-min(y))/20;
        [~,pks]=findpeaks(y,'MinPeakProminence',prom,'MinPeakWidth',5,'MinPeakDistance',20);
        peaktimes=t(pks);
        peaktimes=peaktimes(peaktimes>5*60);	% Skip early peaks
        obj.lane(lane).peaks=peaktimes;
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
    %      sz=interp1(obj.lane(lane).ledpoints(:,1),obj.lane(lane).ledpoints(:,2),mins,'linear','extrap');
      if nargin<4
        atElute=0;
      end
      t=obj.adjTime(lane,mins);
      if atElute
        t=t*obj.eluteScale;
      end
      sz=exp(interp1(1./obj.lane(lane).ledpoints(:,1),log(obj.lane(lane).ledpoints(:,2)),1./t,'linear','extrap'));
    end
    
    function [t,refsused]=sizeToTime(obj,lane,sz,atElute,realTimeLinear)
    % Compute size in nt given mins of propagation
    %mins=interp1(obj.lane(lane).ledpoints(:,2),obj.lane(lane).ledpoints(:,1),sz,'linear','extrap');
      if nargin<4
        atElute=0;
      end
      if nargin<5
        realTimeLinear=0;  % This is 0 to ignore, or the maximum time up to which to use reference peaks
      end
      if realTimeLinear
        sel=obj.lane(lane).ledpoints(:,1)<realTimeLinear;
        t=interp1(obj.lane(lane).ledpoints(sel,2),obj.lane(lane).ledpoints(sel,1),sz,'linear','extrap');
        refsused=obj.lane(lane).ledpoints(sel,2);
      else
        t=1./interp1(log(obj.lane(lane).ledpoints(:,2)),1./obj.lane(lane).ledpoints(:,1),log(sz),'linear','extrap');
        refsused=obj.lane(lane).ledpoints(:,2);
        
      end
      if atElute
        t=t/obj.eluteScale;
      end
      t=obj.realTime(lane,t);
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
      % Mark pause times in red
      pausetimes=obj.Timers(find(obj.PauseFlags))/60;
      for i=1:length(pausetimes)
        plot(pausetimes(i)*[1,1],c(3:4),':r');
      end
      % Mark lane state in green 
      v=(obj.LaneState(:,lane)/2 + 0.1)/1.2 * (c(4)-c(3)) + c(3);
      elutetimes=obj.Timers(obj.LaneState(:,lane)==2)/60;
      h=plot(obj.Timers/60,v,'-g');
      

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
      c(4)=c(4)+(c(4)-c(3));
      axis(c);

      % Plot reference on right axis
      yyaxis right
      plot(c(1):c(2),obj.timeToSize(lane,c(1):c(2)));
      hold on;
      plot(c(1):c(2),obj.timeToSize(lane,c(1):c(2),1));
      ylabel('Size (bp)');
      c=axis;
      c(3:4)=[0,200];
      axis(c);

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
      
      obj.analyzepeaks();

      % references
      ladderbp=[obj.Cassette.Ladder.BP];
      ladderbp=ladderbp(ladderbp>0);
      fprintf('Ladder for %s is [%s]\n', obj.Cassette.Cass, sprintf('%.1f ',ladderbp));
      for i=1:length(obj.lane)
        ref=obj.lane(i).RefLane;
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
        obj.lane(i).ledpoints=[obj.adjTime(ref,peaks/60),ladderbp(1:length(peaks))'];
        if obj.lane(i).TargetBPs.BPpause ~= 0
          pauseStr=sprintf(', pause at %3.0f bp', obj.lane(i).TargetBPs.BPpause);
        else
          pauseStr='';
        end
        fprintf('Setup lane %d (%10s) to use reference lane %d, range=[%3.0f,%3.0f] bps, %s, eluted at %.2f:%.2f min\n', i, obj.lane(i).Name,ref, obj.lane(i).TargetBPs.BPstart,obj.lane(i).TargetBPs.BPend,pauseStr,obj.lane(i).eluteTime);
        obj.lane(i).elutePoints(1,:)=[obj.lane(i).eluteTime(1),obj.lane(i).TargetBPs.BPstart];
        obj.lane(i).elutePoints(end+1,:)=[obj.lane(i).eluteTime(2),obj.lane(i).TargetBPs.BPend];
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
        szs=[l.TargetBPs.BPstart,l.TargetBPs.BPpause,l.TargetBPs.BPend];
        ptime=obj.Timers(find(obj.PauseFlags==10^(7-i)))/60;
        if isempty(ptime)
          ptime=nan;
        end
        actuals=[l.eluteTime(1),ptime,l.eluteTime(2)];
        et=[];refsused={};
        for j=1:length(actuals)
          [et(j),refsused{j}]=obj.sizeToTime(i,szs(j),1,actuals(j)-0.25);
        end
        err=et-actuals;
        fprintf('Lane %d elute [%3.0f %3.0f %3.0f] @ [%.2f %.2f %.2f] -> computed = [%.2f %.2f %.2f] err=[%5.2f %5.2f %5.2f] Refs used=[', i, szs, actuals, et,err);
        for j=1:length(actuals)
          fprintf('{%s} ',sprintf('%.0f ',refsused{j}));
        end
        fprintf(']\n');
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
