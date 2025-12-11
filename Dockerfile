# Build stage
FROM mcr.microsoft.com/dotnet/sdk:9.0-alpine AS build
WORKDIR /app

COPY . .
RUN dotnet restore
RUN dotnet publish -c Release -o /app/published-app

# Runtime stage
FROM mcr.microsoft.com/dotnet/aspnet:9.0-alpine AS runtime
WORKDIR /app

COPY --from=build /app/published-app /app

EXPOSE 5000
ENV ASPNETCORE_HTTP_PORTS=5000

# Alpine-compatible adduser
RUN adduser -u 5678 -D appuser
USER appuser

ENTRYPOINT ["dotnet", "IBASEmployeeService.dll"]
