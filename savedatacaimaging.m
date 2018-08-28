neuron.P.log_folder=convertStringsToChars(pwd+"\"); 
neuron.P.log_file=convertStringsToChars(pwd+"\logs.txt");
neuron.P.log_data=convertStringsToChars(pwd+"\intermediate_results.mat");
create_sesions();
Coor = neuron.show_contours(0.6);
neuron.save_neurons();
cnmfe_path = neuron.save_workspace();