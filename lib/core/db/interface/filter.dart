abstract class Filter {
  filter();
}
/// column operator value
/// filter((v)=> FilterModel(column:v.name,operatorValue:v.name,value:v.name))
/// select * from categories where column operator value;
///  
/// =
/// >=
/// <=
/// like,ilike
/// not like
/// in
/// not in
/// between
/// not between
/// and 
/// is
/// is not
/// or
/// not
