use geo::algorithm::contains::Contains;
use rustler::types::ListIterator;
use rustler::{Encoder, Env, Error, NifResult, ResourceArc, Term};

mod atoms {
    rustler::rustler_atoms! {
        atom ok;
        //atom error;
        atom __true__ = "true";
        atom __false__ = "false";
    }
}

rustler::rustler_export_nifs! {
    "Elixir.Ats.Native",
    [
        ("continent_new", 1, continent_new),
        ("shape_contains?", 2, shape_contains, rustler::SchedulerFlags::DirtyCpu)
    ],
    Some(on_load)
}

type Point = (f64, f64);
type GeoLine = Vec<Point>;
type Polygon = Vec<GeoLine>;
type MultiPolygon = Vec<Polygon>;

struct Continent {
    coordinates: geo::MultiPolygon<f64>,
}

// Define Continent struct on load.
fn on_load<'a>(env: Env<'a>, _load_info: Term<'a>) -> bool {
    rustler::resource_struct_init!(Continent, env);
    true
}

/// Convert a term as a list iterator and map it with a function.
fn map_nif_list<'a, F, U>(term: Term<'a>, f: F) -> NifResult<Vec<U>>
where
    F: Fn(Term<'a>) -> NifResult<U>,
{
    let l: ListIterator = term.decode()?;
    l.map(f).collect()
}

// Decode a number tuple.
fn decode_point<'a>(term: Term<'a>) -> NifResult<Point> {
    let tuple = rustler::types::tuple::get_tuple(term)?;
    let mut iter = tuple.into_iter().map(|x| match x.decode::<f64>() {
        Ok(x) => Ok(x),
        Err(_) => x.decode::<i64>().map(|i| i as f64),
    });
    let a = iter.next().unwrap()?;
    let b = iter.next().unwrap()?;
    Ok((a, b))
}

fn continent_new<'a>(env: Env<'a>, args: &[Term<'a>]) -> Result<Term<'a>, Error> {
    let result: NifResult<MultiPolygon> = map_nif_list(args[0], |x| {
        map_nif_list(x, |y| map_nif_list(y, |z| decode_point(z)))
    });

    let continent = Continent {
        coordinates: create_geo_multi_polygon(&result?),
    };

    Ok(ResourceArc::new(continent).encode(env))
}

fn shape_contains<'a>(env: Env<'a>, args: &[Term<'a>]) -> Result<Term<'a>, Error> {
    let shape: ResourceArc<Continent> = args[0].decode()?;
    let point: (f64, f64) = decode_point(args[1])?;
    let point: geo::Point<f64> = point.into();

    if shape.coordinates.contains(&point) {
        Ok(atoms::__true__().encode(env))
    } else {
        Ok(atoms::__false__().encode(env))
    }
}

// Data conversion

fn create_geo_coordinate(point_type: &Point) -> geo::Coordinate<f64> {
    geo::Coordinate {
        x: point_type.0,
        y: point_type.1,
    }
}

fn create_geo_line_string(line_type: &GeoLine) -> geo::LineString<f64> {
    geo::LineString(
        line_type
            .iter()
            .map(|point_type| create_geo_coordinate(point_type))
            .collect(),
    )
}

fn create_geo_polygon(polygon_type: &Polygon) -> geo::Polygon<f64> {
    let exterior = polygon_type
        .get(0)
        .map(|e| create_geo_line_string(e))
        .unwrap_or_else(|| create_geo_line_string(&vec![]));

    let interiors = if polygon_type.len() < 2 {
        vec![]
    } else {
        polygon_type[1..]
            .iter()
            .map(|line_string_type| create_geo_line_string(line_string_type))
            .collect()
    };

    geo::Polygon::new(exterior, interiors)
}

fn create_geo_multi_polygon(multi_polygon_type: &[Polygon]) -> geo::MultiPolygon<f64> {
    geo::MultiPolygon(
        multi_polygon_type
            .iter()
            .map(|polygon_type| create_geo_polygon(&polygon_type))
            .collect(),
    )
}
