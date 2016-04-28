% Try to figure out how PPrep determines pause points
refs=[20 36.67
      75 42.15
      150 48.4554];
data=[46,43
      60,44.73
      79 47.08
      104 50.18
      116 51.67
      130 53.4
      145 55.23];
setfig('pausecheck');clf;
plot(data(:,2),data(:,1),'o');
hold on;
plot(refs(:,2),refs(:,1),'x');
xlabel('Time (min)');
ylabel('BP');
mdl=polyfit(data(:,2),data(:,1),1);
c=axis;
t=c(1):.5:c(2);
hold on;
plot(t,polyval(mdl,t),':');
error=data(:,1)-polyval(mdl,data(:,2));
rmse=sqrt(mean(error.^2));
fprintf('RMSE=%.2f\n', rmse);

rmdl=polyfit(refs(:,2),refs(:,1),2);
plot(t,polyval(rmdl,t),':');
rmdl1=polyfit(refs(1:2,2),refs(1:2,1),1);
plot(t,polyval(rmdl1,t),':');	% Linear model using only first 2 points
