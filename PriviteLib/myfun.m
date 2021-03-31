function out = myfun(x)
   z  =  M*x;
   f  =  z(1);
 tao  =  z(2:4);
 
 out = w1*(f-fd)^2+w2*(tao(1)-taoxyd(1))^2+w3*(tao(2)-taoxyd(2))^2+w4*(tao(3)-taozd)^2;
   
   
   