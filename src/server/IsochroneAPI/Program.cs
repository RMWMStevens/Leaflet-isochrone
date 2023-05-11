using IsochroneAPI;
using Microsoft.AspNetCore.Mvc;
using System.Data.SqlClient;

var builder = WebApplication.CreateBuilder(args);

var cors = "CorsPolicy";

builder.Services.AddCors(options
    => options.AddPolicy(cors, builder => builder
        .WithOrigins("http://localhost:5500")
        .AllowAnyMethod()
        .SetIsOriginAllowed((host) => true)
        .AllowAnyHeader()
    ));

var app = builder.Build();

app.UseCors(cors);

var connectionString = builder.Configuration.GetConnectionString("DefaultConnection");

app.MapPost("/isochroon", ([FromBody] IsochroneRequest request) =>
{
    using (var connection = new SqlConnection(connectionString))
    {
        using (var command = new SqlCommand("SELECT * FROM [dbo].[KortsteRoutePck_GetGpsVanKnooppunten](@IsochroonCode, @KnooppuntId1, @KortsteRoute)", connection))
        {
            command.Parameters.AddWithValue("@IsochroonCode", request.IsochroonCode);
            command.Parameters.AddWithValue("@KnooppuntId1", request.KnooppuntId);
            command.Parameters.AddWithValue("@KortsteRoute", request.Afstand);

            connection.Open();

            var geoJson = new GeoJson();
            geoJson.Features.Add(new());
            geoJson.Features[0].Geometry.Coordinates.Add(new());
            var coordinates = geoJson.Features[0].Geometry.Coordinates[0];

            using (var reader = command.ExecuteReader())
            {
                while (reader.Read())
                {
                    var latitude = reader["Latitude"].ToString();
                    var longitude = reader["Longitude"].ToString();
                    coordinates.Add(new() { double.Parse(longitude), double.Parse(latitude) });
                }
            }

            return geoJson;
        }
    }
}).RequireCors(cors);

app.Run();
