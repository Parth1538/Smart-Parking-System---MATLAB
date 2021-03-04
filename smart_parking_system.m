format compact
NumberOfCars=0;  %Initially no car is there and parking is empty
availablespace=13; %We have total 13 available space for parking 
a=arduino('com5','Uno','libraries','servo,ExampleLCD/LCDAddon','ForceBuild',true);

%Now let’s give connection to lcd libraries and connection 
lcd=addon(a,'ExampleLCD/LCDAddon',{'D7','D6','D5','D4','D3','D2'});
initializeLCD(lcd,'Rows', 2, 'Columns', 16);  % initializing LCD 

% Giving Servo motor connection 
s=servo(a,'D9','MinPulseDuration',700*10^-6,'Maxpulseduration',2300*10^-6);
configurePin(a,'A1','DigitalInput');
configurePin(a,'A2','DigitalInput'); 
writeDigitalPin(a,'D13',1); 
writeDigitalPin(a,'D12',0);
writePosition(s,0); 

% at first lcd is clear 
clearLCD(lcd); 

printLCD(lcd,'SMART PARKING');
printLCD(lcd,['Empty slots:',num2str(availablespace)]) 
%using while condition to manipulate number of parking slots, red and green
%light and servo motor

while 1  % This will run in loop till the condition is true
    enter_push=readDigitalPin(a,'A1')
    exit_push=readDigitalPin(a,'A2')
    if availablespace>0
        if enter_push==true 
            clearLCD(lcd);
            printLCD(lcd,'Welcome!!!! ')
            availablespace=availablespace-1;
            writeDigitalPin(a,'D12',1);
            writeDigitalPin(a,'D13',0);
            writePosition(s,0.5)
            pause(2) 
            writePosition(s,0)
            str1='Empty slots = '; 
            str2=num2str(availablespace); 
            printLCD(lcd,strcat(str1,str2));
        end
        writeDigitalPin(a,'D12',0);
        writeDigitalPin(a,'D13',1);
    else
        clearLCD(lcd); 
        printLCD(lcd,'Plz Come Later'); 
    end
    if availablespace<13
        if exit_push==true 
            writeDigitalPin(a,'D12',1); 
            writeDigitalPin(a,'D13',0); 
            clearLCD(lcd); 
            printLCD(lcd,'Have a safedrive') 
            availablespace=availablespace+1; 
            str1='Empty slots = ';
            str2=num2str(availablespace); 
            printLCD(lcd,strcat(str1,str2)); 
            writePosition(s,0.5)
            pause(2)
            writePosition(s,0)
        end
        writeDigitalPin(a,'D12',0); 
        writeDigitalPin(a,'D13',1); 
    end
end

