.mode ascii

-- Show duplicated symbols
select exchange,symbol,type,count() from symbols group by exchange,type,symbol having count()>1;

-- Show multi markets not define to main market
SELECT * FROM euronext_equities WHERE multi_markets AND contains(market,',');
