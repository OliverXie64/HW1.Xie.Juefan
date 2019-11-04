clc
clear; 
clf; 

dim=2;    % dimension of system
b=10;      % number of bars
s=10;      % number of strings
m=b+s;    % number of members
q=10;      % number of free nodes Q
p=5;      % number of fixed nodes P
fixed_node_index=[5 9 12 14 15];
free_node_index=[1 2 3 4 6 7 8 10 11 13];
n=q+p;    % number of nodes
phi=pi/16; % angle phi
beta=pi/6; % angle beta

% Now construct the 3-dimensional balloon configuration from above parameters
% Locations of free nodes are P=P_(dim x p) and fixed nodes are Q=Q_(dim x q)
C=zeros(m,n);                               % Connectivity matrix
% compute each member's connection 
node_connection=zeros(20,3);
node_connection(:,1)=linspace(1,20,20).';
node_connection(:,2:3)=[
    1 2;
    2 3;
    3 4;
    4 5;
    6 7;
    7 8;
    8 9;
    10 11;
    11 12;
    13 14;
    13 15;
    10 13;
    6 10;
    1 6;
    11 14;
    7 11;
    2 7;
    8 12;
    3 8;
    4 9
    ];

% compute coordinate for each node
a=sin(beta)/sin(beta+phi);
r1=10;
r2=a*r1;
r3=a*r2;
r4=a*r3;
r5=a*r4;
node_properties=zeros(n,3);
node_properties(:,1)=linspace(1,n,1).';
node_properties(:,2:3)=[
    r1 0;
    r2 -1;
    r3 -2;
    r4 -3;
    r5 -4; %node 5
    r2 1;
    r3 0;
    r4 -1;
    r5 -2;
    r3 2;  %node 10
    r4 1;
    r5 0;
    r4 3;
    r5 2;
    r5 4;  %node 15
    ];
node_position=zeros(n,3);
node_position(:,1)=linspace(1,n,1).';
for i=1:n
    r=node_properties(i,2);
    angle=node_properties(i,3)*phi;
    X=r*cos(angle);
    Y=r*sin(angle);
    node_position(i,2:3)=[X,Y];
end
Q=node_position(free_node_index,2:3).';
P=node_position(fixed_node_index,2:3).';

% compute connectivity matrix 
for i=1:20
   C(i,node_connection(i,2))=1;
   C(i,node_connection(i,3))=-1;
end
temp=C(:,fixed_node_index);
C(:,fixed_node_index)=[];
C=[C temp];
  
% Define applied external force U
U1(1:dim,1:10)=0; U1(1,1)=1; % point load
U2(1:dim,1:10)=0; U2(1,:)=0.5; % uniform load
U3(1:dim,1:10)=0; U3(2,:)=-0.1;  % gravity


% solve for the forces at equilibrium.
[c_bars,t_strings,V]=tensegrity_statics(b,s,q,p,dim,Q,P,C,U1);
fig1=figure(1); tensegrity_plot(Q,P,C,b,s,U1,V); axis equal
title('4th Order Mitchell Truss with Single Point Load')
saveas(fig1,'Mitchel_single_point_load','png')

[c_bars,t_strings,V]=tensegrity_statics(b,s,q,p,dim,Q,P,C,U2);
fig2=figure(2); tensegrity_plot(Q,P,C,b,s,U2,V); axis equal
title('4th Order Mitchell Truss with Uniform Load')
saveas(fig2,'Mitchel_uniform_load','png')

[c_bars,t_strings,V]=tensegrity_statics(b,s,q,p,dim,Q,P,C,U3);
fig2=figure(2); tensegrity_plot(Q,P,C,b,s,U3,V); axis equal
title('4th Order Mitchell Truss under Gravity')
saveas(fig2,'Mitchel_gravity_load','png')
