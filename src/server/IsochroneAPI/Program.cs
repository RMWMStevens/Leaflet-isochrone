using IsochroneAPI;
using Microsoft.AspNetCore.Mvc;
using System.Data.SqlClient;

var builder = WebApplication.CreateBuilder(args);
var app = builder.Build();

var connectionString = builder.Configuration.GetConnectionString("DefaultConnection");

app.MapGet("/isochroon", ([FromBody] IsochroneRequest request) =>
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
                    coordinates.Add(new() { double.Parse(latitude), double.Parse(longitude) });
                }
            }

            return geoJson;
        }
    }
});

app.Run();
