(function(global){
  const VALID_TYPES=['ANTICIPO','ABONO','PAGO_FINAL','OTRO'];
  const VALID_STATUS=['CONFIRMADO','REVERSADO'];
  const n=v=>Math.round(Number(v)||0);
  function createPayment(input){
    const amount=n(input.amount);
    if(amount<=0) throw new Error('El monto debe ser positivo');
    if(!VALID_TYPES.includes(input.type)) throw new Error('Tipo de pago inválido');
    return Object.freeze({
      id:input.id||`PAY-${Date.now()}`,
      projectId:input.projectId||null,
      type:input.type,
      date:input.date,
      amount,
      method:input.method||'TRANSFERENCIA',
      reference:input.reference||null,
      receiptDocumentId:input.receiptDocumentId||null,
      status:'CONFIRMADO',
      note:input.note||null
    });
  }
  function reversePayment(payment,reason){
    if(!payment||payment.status!=='CONFIRMADO') throw new Error('Solo pagos confirmados pueden reversarse');
    return Object.freeze({...payment,status:'REVERSADO',reversalReason:reason||'Sin motivo',reversedAt:new Date().toISOString()});
  }
  function confirmedTotal(payments){return payments.filter(p=>p.status==='CONFIRMADO').reduce((s,p)=>s+n(p.amount),0)}
  function collectionSummary(currentSale,payments){
    const sale=n(currentSale),collected=confirmedTotal(payments),pending=Math.max(0,sale-collected);
    let state='SIN_PAGOS';
    if(collected>0&&pending>0) state='PARCIAL';
    if(sale>0&&pending===0) state=collected>sale?'SOBREPAGO':'PAGADO';
    return {sale,collected,pending,state,overpayment:Math.max(0,collected-sale)};
  }
  function runPaymentTests(){
    const a=createPayment({id:'P1',type:'ANTICIPO',date:'2026-09-09',amount:300000});
    const b=createPayment({id:'P2',type:'ABONO',date:'2026-09-10',amount:200000,receiptDocumentId:'DOC-DEMO-1'});
    const s1=collectionSummary(1000000,[a,b]);
    const rb=reversePayment(b,'Error demo');
    const s2=collectionSummary(1000000,[a,rb]);
    const c=createPayment({id:'P3',type:'PAGO_FINAL',date:'2026-09-11',amount:700000});
    const s3=collectionSummary(1000000,[a,c]);
    return Object.isFrozen(a)&&s1.collected===500000&&s1.pending===500000&&s1.state==='PARCIAL'&&s2.collected===300000&&s2.pending===700000&&s3.pending===0&&s3.state==='PAGADO'&&b.receiptDocumentId==='DOC-DEMO-1';
  }
  const api={VALID_TYPES,VALID_STATUS,createPayment,reversePayment,confirmedTotal,collectionSummary,runPaymentTests};
  if(typeof module!=='undefined'&&module.exports) module.exports=api;
  global.BurdeoPaymentsV1=api;
})(typeof window!=='undefined'?window:globalThis);
