clear all
clc

dim=3;    % dimension of system
b=4;      % number of bars
s=24;      % number of strings
m=b+s;    % number of members
q=8;      % number of free nodes Q
p=0;      % number of fixed nodes P
n=q+p;    % number of nodes

% Locations of 8 free nodes
Q=zeros(dim,q);
Q(:,1)=[0; 0;   0];
Q(:,2)=[1; 0;   0];
Q(:,3)=[1; 1;   0];
Q(:,4)=[0; 1;   0];
Q(:,5)=[0; 0;   1]; 
Q(:,6)=[1; 0;   1];
Q(:,7)=[1; 1;   1];
Q(:,8)=[0; 1;   1];
P=zeros(1,p);

C=zeros(m,n);             % Connectivity matrix 
C( 1,1)=1; C( 1,7)=-1;    % bars 
C( 2,2)=1; C( 2,8)=-1;
C( 3,3)=1; C( 3,5)=-1;
C( 4,4)=1; C( 4,6)=-1;

C( 5,1)=1; C( 5,5)=-1;    % 4 vertical strings
C( 6,2)=1; C( 6,6)=-1;    
C( 7,3)=1; C( 7,7)=-1;    
C( 8,4)=1; C( 8,8)=-1;    

C( 9,5)=1; C( 9,6)=-1;    % 8 side strings on top and bottom 
C(10,6)=1; C(10,7)=-1;    
C(11,7)=1; C(11,8)=-1;    
C(12,5)=1; C(12,8)=-1;    
C(13,1)=1; C(13,2)=-1;    
C(14,2)=1; C(14,3)=-1;   
C(15,3)=1; C(15,4)=-1;   
C(16,1)=1; C(16,4)=-1;   

C(17,5)=1; C(17,7)=-1;    % 4 diagonal strings on top and bottom 
C(18,6)=1; C(18,8)=-1;
C(19,2)=1; C(19,4)=-1;
C(20,1)=1; C(20,3)=-1;

C(21,1)=1; C(21,6)=-1;    % 8 diagonal strings on 4 sides
C(22,2)=1; C(22,5)=-1;
C(23,3)=1; C(23,6)=-1;
C(24,2)=1; C(24,7)=-1;
C(25,3)=1; C(25,8)=-1;
C(26,4)=1; C(26,7)=-1;
C(27,1)=1; C(27,8)=-1;
C(28,4)=1; C(21,5)=-1;

% External force U for every node
U1=zeros(dim,n); U1(3,1:4) = 1;U1(3,5:8) = -1; % uniform compression
U2=zeros(dim,n); U2(3,1:4) = -0.1;U2(3,5:8) = 0.1; % uniform tension
U3=zeros(dim,n);U3(3,1) =-1; U3(3,5) = 1; % single point tension
U4=zeros(dim,n); % no loading


% Finally, solve for the forces at equilibrium.
[c_bars,t_strings,V]=tensegrity_statics(b,s,q,p,dim,Q,P,C,U1);
fig1=figure(1); 
title('Under Uniform Compression')
tensegrity_plot(Q,P,C,b,s,U1,V); axis equal
saveas(fig1,'uniformCompression.png')

[c_bars,t_strings,V]=tensegrity_statics(b,s,q,p,dim,Q,P,C,U2);
fig2=figure(2); 
title('Under Uniform Tension')
tensegrity_plot(Q,P,C,b,s,U2,V); axis equal
saveas(fig2,'uniformTension.png')

[c_bars,t_strings,V]=tensegrity_statics(b,s,q,p,dim,Q,P,C,U3);
fig3=figure(3); 
title('Under Single=point Tension')
tensegrity_plot(Q,P,C,b,s,U3,V); axis equal
saveas(fig3,'singlePointTension.png')

[c_bars,t_strings,V]=tensegrity_statics(b,s,q,p,dim,Q,P,C,U4);
fig4=figure(4); 
title('Under No Load')
tensegrity_plot(Q,P,C,b,s,U4,V); axis equal
saveas(fig4,'noLoad.png')
