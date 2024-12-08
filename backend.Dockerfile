FROM mcr.microsoft.com/dotnet/aspnet:8.0 AS base
USER $APP_UID
WORKDIR /app
EXPOSE 8080
EXPOSE 8081

FROM mcr.microsoft.com/dotnet/sdk:8.0 AS build
ARG BUILD_CONFIGURATION=Release
WORKDIR /src
COPY ["PassedPawn.API/PassedPawn.API.csproj", "PassedPawn.API/"]
COPY ["PassedPawn.DataAccess/PassedPawn.DataAccess.csproj", "PassedPawn.DataAccess/"]
COPY ["PassedPawn.Models/PassedPawn.Models.csproj", "PassedPawn.Models/"]
COPY ["PassedPawn.BusinessLogic/PassedPawn.BusinessLogic.csproj", "PassedPawn.BusinessLogic/"]
RUN dotnet restore "PassedPawn.API/PassedPawn.API.csproj"
RUN dotnet restore "PassedPawn.DataAccess/PassedPawn.DataAccess.csproj"
RUN dotnet restore "PassedPawn.Models/PassedPawn.Models.csproj"
RUN dotnet restore "PassedPawn.BusinessLogic/PassedPawn.BusinessLogic.csproj"
COPY . .
WORKDIR "/src/PassedPawn.API"
RUN dotnet build "PassedPawn.API.csproj" -c $BUILD_CONFIGURATION -o /app/build

FROM build AS publish
ARG BUILD_CONFIGURATION=Release
RUN dotnet publish "PassedPawn.API.csproj" -c $BUILD_CONFIGURATION -o /app/publish /p:UseAppHost=false

FROM base AS final
WORKDIR /app
COPY --from=publish /app/publish .
ENTRYPOINT ["dotnet", "PassedPawn.API.dll"]
