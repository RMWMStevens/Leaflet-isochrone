namespace IsochroneAPI
{
    public class GeoJson
    {
        public string Type { get; set; } = "FeatureCollection";

        public List<Feature> Features { get; set; } = new();
    }

    public class Feature
    {
        public string Type { get; set; } = "Feature";

        public Geometry Geometry { get; set; } = new();

        public Properties Properties { get; set; } = new();
    }

    public class Geometry
    {
        public string Type { get; set; } = "Polygon";

        public List<List<List<double>>> Coordinates { get; set; } = new();
    }

    public class Properties
    {
        public int Time { get; set; } = 1;

        public int Value { get; set; } = 1;
    }
}
