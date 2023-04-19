clc;clear;close all

vertical = 2;
horizontal = 2; 
aBS = qd_arrayant ('3gpp-3d', vertical, horizontal);
aMS = qd_arrayant('omni');
aMS.copy_element(1,2);

l = qd_layout(); 
l.simpar.show_progress_bars = 0;
l.simpar.use_3GPP_baseline = 1;
l.tx_array = aBS;
l.rx_array = aMS;
l.randomize_rx_positions(200,1.5,15,0,[],55);
l.set_scenario('3GPP_38.901_UMa',[],[],0);   

b = l.init_builder;
b.gen_parameters();

cm = get_channels(b); 
size(cm.coeff)

H = cm.coeff;

plotImpulseFrequencyResponses1(1,2,H,2e10,cm.delay);


