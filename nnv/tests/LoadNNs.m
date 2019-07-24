%% Run examples to load a FNN from different formats using nnmt
[v,e,l] = pyversion;
% Check OS running on
osc = computer;
if contains(osc,'WIN')
    sh = '\'; % windows
else 
    sh = '/'; % mac and linux
end

% Find the path to the python to use, in case that python does not have all
% dependencies needed, look at help pyversion and py.sys.path to choose the
% correct python environment
e = split(string(e),sh);
e = erase(e,e(end));
pypath = strjoin(e,sh);

% Get paths to the inputs for the first example
genp = split(string(pwd),sh);
rp = {'nnv','nnv','tests'};
if ~isequal(genp(end-2:end),string(rp)')
    error('Executing from %s. \nPlease, change your current folder path to ../nnv/nnv/tests and run script again',pwd);
end
cd ..
fp = pwd; % Final path used for calling all the future examples
cont1 = load_nn(pypath,[fp sh 'engine' sh 'nnmt'],[fp sh 'engine' sh 'nnmt' sh 'original_networks' sh 'neural_network_information_13'],[fp sh 'engine' sh 'nnmt' sh 'translated_networks'],'Sherlock',[]);
