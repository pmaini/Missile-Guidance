function angle = atan3(y,x)

tempA = atan2(y,x);

if tempA<0
    tempA = tempA+(2*pi);
end

angle = tempA;

