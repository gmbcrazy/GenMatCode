function y=bottom_climax_change(Data)
a=find(Data>=180);
b=find(Data<180);
Data(a)=Data(a)-180;
Data(b)=Data(b)+180;
y=Data;