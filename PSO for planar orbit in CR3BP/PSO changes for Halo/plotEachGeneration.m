function stop = plotEachGeneration(optimValues,state)

%h1=figure(1);
%set(h1,'name','particleswarm');
if state == 'iter'
    scatter(optimValues.swarm(:,1),optimValues.swarm(:,2),'ob'); hold on;
    scatter(optimValues.bestx(1), optimValues.bestx(2),'*r');
    xlabel('x_0');
    ylabel('v_{y0}');
    title('Swarm Positions');
    hold off;
end
stop = false;

end