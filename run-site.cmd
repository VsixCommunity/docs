dotnet tool install --global dotnet-serve

cd docs
start cmd /k dotnet-serve -o -d _site
jekyll b -w