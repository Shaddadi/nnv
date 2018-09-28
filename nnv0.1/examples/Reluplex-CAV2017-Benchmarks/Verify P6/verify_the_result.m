load F.mat;

R = F.outputSet;
n = length(R); 

% plot sample and reach set


lb1 = [12000; 0.7; -3.141592; 100; 0.0];
ub1 = [62000; 3.141592; -3.141592 + 0.005; 1200; 1200];
n=5000;
x1 = (ub1(1) - lb1(1)).*rand(n, 1) + lb1(1);
x2 = (ub1(2) - lb1(2)).*rand(n, 1) + lb1(2);
x3 = (ub1(3) - lb1(3)).*rand(n, 1) + lb1(3);
x4 = (ub1(4) - lb1(4)).*rand(n, 1) + lb1(4);
x5 = (ub1(5) - lb1(5)).*rand(n, 1) + lb1(5);

I = [x1'; x2'; x3'; x4'; x5'];

Y = F.sample(I);

output = Y{1, 7};
maps = [0 0 0 1 0; 0 0 0 0 1; 0 0 1 0 0];
output_mapped = maps*output;

R1 = [];
for i=1:length(R)
    R1 = [R1 R(i).affineMap(maps)];   
end

fig = figure;
R1.plot;
hold on;
plot3(output_mapped(1, :), output_mapped(2, :), output_mapped(3, :), 'o');


% find a counter example

n = length(output);

counter_O = [];
counter_I = [];

for i=1:n
    [temp, idx] = min(output(:, i));
    if idx ~=1
        fprintf('\nInput %d produce counter example', i);
        fprintf('\nThis is the output of the neural network:')
        display(output(:, i));
        fprintf('\nThis is the corresponding input for above output');
        display(I(:, i));
        counter_O = [counter_O output(:,i)];
        counter_I = [counter_I I(:, i)];
    end
end
