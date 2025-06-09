# Use an official .NET runtime as a parent image
FROM mcr.microsoft.com/dotnet/aspnet:6.0 AS base # Or 8.0 if you chose net8.0 in csproj
WORKDIR /app
EXPOSE 80
# Use an official .NET SDK image to build your application
FROM mcr.microsoft.com/dotnet/sdk:6.0 AS build # Or 8.0 if you chose net8.0 in csproj
WORKDIR /src
COPY ["MyDockerWebApp-DotNet.csproj", "."]
RUN dotnet restore
COPY . .
WORKDIR "SRC/."
RUN dotnet build
#publish the application
FROM build AS publish
RUN dotnet publish "MyDockerWebApp-DotNet.csproj" -c Release -o /app/publish /p:UseAppHost=false
# final stage : create a runtime
FROM base AS final
WORKDIR /app
COPY --from=publish app/publish
ENTRYPOINT ["dotnet" , "MyDockerWebApp-DotNet.dll"] # The name of your compiled DLL
