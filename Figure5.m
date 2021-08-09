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

% Parameters for changing To
epsilon= -.001; %rate of change (positive if To increases, negative if to decreases
maxenv = 7.5;  %Maximum To (used only when simulating a deteriorating environment)
minenv = 5;    %Minimum To (used only when simulating an management intervention)

% Time of simulation
tmax1 = 50000;

%Find initial conditions with no evolution

sigma   = 0;
y0      = [9 0.01 1 0]; %initial conditions: [To A M meanx]
fod     = @(t,y) ODEecoevowithEnv(t,y,epsilon,9,maxenv,0,0,rA,rM,K,hA,hM,theta,lamda,sigma,tau);
[tini,yini] = ode23(fod,[0 1000],y0);

%Dynamics ecological model

sigma   = 0;
fod     = @(t,y) ODEecoevowithEnv(t,y,epsilon,minenv,maxenv,0,0,rA,rM,K,hA,hM,theta,lamda,sigma,tau);
[teco,yeco] = ode23(fod,[0 tmax1],yini(end,:));

%Find initial conditions with evolution

sigma   = 0.05;
y0      = [9 0.01 1 0]; %initial conditions: [To A M meanx]
fod     = @(t,y) ODEecoevowithEnv(t,y,epsilon,9,maxenv,0,0,rA,rM,K,hA,hM,theta,lamda,sigma,tau);
[tini,yini] = ode23(fod,[0 100000],y0);

%Dynamics eco-evolutionary model

sigma   = 0.05;
y0      = [0.01 0.01 1 0]; %initial conditions: [To A M meanx]
fod     = @(t,y) ODEecoevowithEnv(t,y,epsilon,minenv,maxenv,0,0,rA,rM,K,hA,hM,theta,lamda,sigma,tau);
[tecoevo,yecoevo] = ode23(fod,[0 tmax1],yini(end,:));

%Plotting

figure
suptitle('Figure 5')
subplot(2,1,1)
plot(teco,yeco(:,1),'k')
ylabel('Nutrient loading (To)')

subplot(2,1,2)
yyaxis left
hold on
plot(tecoevo,yecoevo(:,4))
plot(teco,yeco(:,4))
ylim([-1 10])
ylabel('Mean trait (x)')
yyaxis right
hold on
plot(tecoevo,yecoevo(:,3))
plot(teco,yeco(:,3))
ylim([0 1])
xlabel('Time (days)')
ylabel('Macrophyte density (M)')
legend('Evolution - Mean trait','No evolution - Mean trait','Evolution - Macrophyte density','No evolution - Macrophyte density')