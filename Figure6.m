clear

% Parameters

rM    = .05;
rA    = .1;
K     = 1;
hA    = 2;
hM    = 0.2;
theta = 0;
lamda = .1;
tau   = 5;
sigma   = 0.05;

% Parameters for changing To
maxenv = 9;  %Maximum To (used only when simulating a deteriorating environment)
minenv = 5;    %Minimum To (used only when simulating an management intervention)

% EARLY INTERVENTION

tinterv = 10000; %time intervention

% Environment deterioration

epsilon = .001; %rate of change (positive if To increases, negative if to decreases
y0      = [0.01 0.01 1 0]; %initial conditions: [To A M meanx]
fod     = @(t,y) ODEecoevowithEnv(t,y,epsilon,minenv,maxenv,0,0,rA,rM,K,hA,hM,theta,lamda,sigma,tau);
[t1,y1] = ode23(fod,[0 tinterv],y0);

% After intervention

epsilon = -.001; %rate of change (positive if To increases, negative if to decreases
y0      = y1(end,:); %initial conditions: [To A M meanx]
fod     = @(t,y) ODEecoevowithEnv(t,y,epsilon,minenv,maxenv,0,0,rA,rM,K,hA,hM,theta,lamda,sigma,tau);
[t2,y2] = ode23(fod,[0 1E5-tinterv],y0);

tearly = [t1; t1(end,1) + t2];
yearly = [y1; y2];

% LATE INTERVENTION

tinterv = 50000; %time intervention

% Environment deterioration

epsilon = .001; %rate of change (positive if To increases, negative if to decreases
y0      = [0.01 0.01 1 0]; %initial conditions: [To A M meanx]
fod     = @(t,y) ODEecoevowithEnv(t,y,epsilon,minenv,maxenv,0,0,rA,rM,K,hA,hM,theta,lamda,sigma,tau);
[t3,y3] = ode23(fod,[0 tinterv],y0);

% After intervention

epsilon = -.001; %rate of change (positive if To increases, negative if to decreases
y0      = y3(end,:); %initial conditions: [To A M meanx]
fod     = @(t,y) ODEecoevowithEnv(t,y,epsilon,minenv,maxenv,0,0,rA,rM,K,hA,hM,theta,lamda,sigma,tau);
[t4,y4] = ode23(fod,[0 1E5-tinterv],y0);

tlate = [t3; t3(end,1) + t4];
ylate = [y3; y4];

%Plotting

figure
suptitle('Figure 6')
subplot(2,1,1)
hold on
plot(tearly,yearly(:,1),'k')
plot(tlate,ylate(:,1),'k--')
ylim([0 10])
ylabel('Nutrient loading (To)')
legend('Early intervention','Late intervention')

subplot(2,1,2)
yyaxis left
hold on
plot(tearly,yearly(:,4))
plot(tlate,ylate(:,4))
ylim([0 10])
ylabel('Mean trait (x)')
yyaxis right
hold on
plot(tearly,yearly(:,3))
plot(tlate,ylate(:,3))
ylim([0 1])
xlabel('Time (days)')
ylabel('Macrophyte density (M)')