.mode ascii

-- Show all duplicate indices
SELECT INDEX,MARKET,count(*) from indices group by INDEX,MARKET having count(*) > 1;

-- Show all empty names
SELECT * from indices where name=='';
