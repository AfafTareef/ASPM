 function inputShape=Domain_Transform(inputShape,Transform)

c = Transform.c;
T = Transform.T;
b = Transform.b;

inputShape=((inputShape-c)*T^-1)/b;

inputShape=round(inputShape);
 end