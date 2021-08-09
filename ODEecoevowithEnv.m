function dy = ODEecoevowithEnv(t,y,omega,minenv,maxenv,int,tint,vrT,vrM,vK,vhT,vhM,vtheta,vlam,vsigma,vtau)

% This ODE includes the differential equation system of Algae (turbidity),
% Macrophyte, mean trait value meanx, and the change in environment To
% It calculates the fitness and fitness gradient numerically

% dy(1) = dTo/dt
% dy(2) = dTurbity/dt
% dy(3) = dMacrophyte/dt
% dy(4) = dmeanx/dt

    dy=zeros(4,1);    
    
    if int==0 %no intervention
        if omega>0 && y(1)<maxenv
            dy(1) = omega; % dTo/dt
        elseif omega<0 && y(1)>minenv
            dy(1) = omega; % dTo/dt
        else
            dy(1) = 0;
        end
    else
        if t<tint %before intervention
            dy(1) = 0;
        else %after intervention
            if omega>0 && y(1)<maxenv
                dy(1) = omega; % dTo/dt
            elseif omega<0 && y(1)>minenv
                dy(1) = omega; % dTo/dt
            else
                dy(1) = 0;
            end
        end
    end
    
    if vsigma>0 %if genetic trait variance is positive
        %fitness    
        funW  = @(x) (vrM.*(1-y(3)./(vK.*exp(-(x-vtheta).^2./(2.*vtau.^2))).*((vhT.*exp(vlam.*x)).^4+y(2).^4)./(vhT.*exp(vlam.*x)).^4)).*(1./(vsigma.*(2.*pi).^(1/2)).*exp(-(x-y(4)).^2./(2.*vsigma.^2)));
        Wmean = integral(funW,-20,20); %Mean fitness
        fundW = @(x) (vrM.*(1-y(3)./(vK.*exp(-(x-vtheta).^2./(2.*vtau.^2))).*((vhT.*exp(vlam.*x)).^4+y(2).^4)./(vhT.*exp(vlam.*x)).^4)).*((x-y(4))./(vsigma.^3.*(2.*pi).^(1/2)).*exp(-(x-y(4)).^2./(2.*vsigma.^2)));
        dWdx=integral(fundW,-20,20); %fitness gradient
    else % if there is not genetic trait variance
        Wmean = vrM*(1-y(3)./vK*(vhT^4+y(2)^4)/vhT^4);%per capita growth rate
        dWdx  = 0;
    end
    
    dy(2) = vrT*y(2)*(1 - y(2)/y(1)*(vhM+y(3))/vhM); % dA/dt
    dy(3) = y(3)*Wmean; % dM/dt
    dy(4) = vsigma*dWdx; % dmeanx/dt
end