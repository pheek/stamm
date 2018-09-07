mysql < ../credentials/grant.sql

mysql -h localhost < 1A_Framework.sql


mysql -h localhost < 2A_Fachklassen.sql
mysql -h localhost < 2B_StoredProcedures.sql
echo ' data: '
mysql -h localhost < 2C_Daten.sql
echo '... done(data).'
echo 'views:'
mysql -h localhost < 3ACreateViews.sql
mysql -h localhost < 9ATests.sql
