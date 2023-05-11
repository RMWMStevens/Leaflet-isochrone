using IsochroneAPI;
using Microsoft.AspNetCore.Mvc;

var builder = WebApplication.CreateBuilder(args);
var app = builder.Build();

var connectionString = builder.Configuration.GetConnectionString("DefaultConnection");

app.MapGet("/isochroon", ([FromBody] IsochroneRequest request) =>
{
    return $"{request.IsochroonCode}: {request.KnooppuntId}, {request.Afstand} meters";
});

app.Run();
