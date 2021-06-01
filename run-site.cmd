dotnet tool install --global dotnet-serve

cd docs
start cmd /k jekyll b -w
dotnet-serve -o -d _site