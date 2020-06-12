use geo::algorithm::contains::Contains;
use rustler::types::ListIterator;
use rustler::{Encoder, Env, Error, NifResult, Term};
use serde_rustler::from_term;
use std::convert::TryInto;

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
        ("shape_contains?", 2, shape_contains, rustler::SchedulerFlags::DirtyCpu)
    ],
    None
}

type Point = Vec<f64>;

type MultiPolygon = Vec<Vec<Vec<Point>>>;

fn shape_contains<'a>(env: Env<'a>, args: &[Term<'a>]) -> Result<Term<'a>, Error> {
    let l1: ListIterator = args[0].decode()?;
    let result: NifResult<Vec<Vec<Vec<Point>>>> = l1
        .map(|x| {
            let l2: ListIterator = x.decode()?;
            let result: NifResult<Vec<Vec<Point>>> = l2
                .map(|x| {
                    let l3: ListIterator = x.decode()?;
                    let result: NifResult<Vec<Point>> = l3
                        .map(|x| {
                            let tuple = rustler::types::tuple::get_tuple(x)?;
                            tuple
                                .into_iter()
                                .map(|x| match x.decode::<f64>() {
                                    Ok(x) => Ok(x),
                                    Err(_) => x.decode::<i64>().map(|i| i as f64),
                                })
                                .collect()
                        })
                        .collect();
                    result
                })
                .collect();
            result
        })
        .collect();
    let shape: MultiPolygon = result?;
    let point: (f64, f64) = from_term(args[1])?;

    let shape: geo::MultiPolygon<f64> = geojson::Value::MultiPolygon(shape).try_into().unwrap();
    let point: geo::Point<f64> = point.into();

    if shape.contains(&point) {
        Ok(atoms::__true__().encode(env))
    } else {
        Ok(atoms::__false__().encode(env))
    }
}
