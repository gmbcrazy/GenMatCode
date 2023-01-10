function testcorr(m)
mouse_date='481_121016'; unit_name='t1a'; firstsession_nb=6;
CorrTable=NaN(5,5);
for i=1:4
    %j=i;
    for j=2:3
        map1_filename=[mouse_date '_s' num2str(firstsession_nb+(i-1)) '_' unit_name  '_map' num2str(i) '.txt' ];
        map2_filename=[mouse_date '_s' num2str(firstsession_nb+(j-1)) '_' unit_name  '_map' num2str(j) '.txt' ];
        map1 = load (map1_filename);
        map2 = load (map2_filename);
        CorrTable(i,j) = zeroLagCorrelation(map1,map2);
        
        xlswrite(TableName, CorrTable, 'B20:F24');    
    end
end
