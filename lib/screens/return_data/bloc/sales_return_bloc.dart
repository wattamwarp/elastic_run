import 'package:elastic_run/dao/sales_return_dao.dart';
import 'package:elastic_run/dao/sales_return_item_dao.dart';
import 'package:elastic_run/main.dart';
import 'package:elastic_run/screens/return_data/bloc/sales_return_event.dart';
import 'package:elastic_run/screens/return_data/bloc/sales_return_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class SalesReturnBloc extends Bloc<SalesReturnEvent, SalesReturnState> {
  final SalesReturnDao _salesReturnDao = SalesReturnDao(database!);
  final SalesReturnItemDao _salesReturnItemDao = SalesReturnItemDao(database!);

  SalesReturnBloc() : super(SalesReturnInitial()) {
    on<LoadSalesReturnsEvent>(_loadSalesReturns);
  }

  Future<void> _loadSalesReturns(
      LoadSalesReturnsEvent event, Emitter<SalesReturnState> emit) async {
    try {
      final salesReturns = await _salesReturnDao.getAllSalesReturns();
      for (var salesReturn in salesReturns) {
        final items = await _salesReturnItemDao
            .getSalesReturnItemsByReturnId(salesReturn.id);
        salesReturn.items.addAll(items);
      }
      emit(SalesReturnLoaded(salesReturns: salesReturns));
    } catch (e) {
      emit(SalesReturnError(error: e.toString()));
    }
  }
}
