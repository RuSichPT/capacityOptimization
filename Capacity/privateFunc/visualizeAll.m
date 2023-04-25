function visualizeAll(l)
    l.visualize([],[],0);
    view(-33, 60);
    axis([-500 500 -500 500]) 
    
    [ map,x_coords,y_coords] = l.power_map( '3GPP_38.901_UMa_NLOS','quick',5,-500,500,-500,500,1.5 );
    P = sum(cat(3,map{:}),3);               % Total received power сумма по Rx
    P = sum(cat(4,P),4);                    % Total received power сумма по Tx
    P = 10*log10(P);
    
    l.visualize([],[],0);                                   % Show BS and MT positions on the map
    hold on
    imagesc( x_coords, y_coords, P );                       % Plot the received power
    hold off
    axis([-500 500 -500 500])                               % Plot size
    caxis( max(P(:)) + [-20 0] )                            % Color range 
    colmap = colormap;
    colormap( colmap*0.5 + 0.5 );                           % Adjust colors to be "lighter"
    set(gca,'layer','top')                                  % Show grid on top of the map
    title('Antenna orientation');                 % Set plot title
end