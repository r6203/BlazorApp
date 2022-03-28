# https://hub.docker.com/_/microsoft-dotnet
FROM mcr.microsoft.com/dotnet/sdk:6.0 AS build
WORKDIR /app

# copy csproj and restore as distinct layers
COPY blazorapp/*.csproj ./blazorapp/
RUN dotnet restore -r linux-x64 ./blazorapp/BlazorApp.csproj

# copy everything else and build app
COPY blazorapp/. ./blazorapp/
WORKDIR /app/blazorapp

RUN dotnet publish ./BlazorApp.csproj -c release -o /out -r linux-x64 --self-contained #--no-restore

# final stage/image
FROM mcr.microsoft.com/dotnet/aspnet:6.0-bullseye-slim-amd64
WORKDIR /app
COPY --from=build ./out ./

 ENTRYPOINT ["./BlazorApp"]
