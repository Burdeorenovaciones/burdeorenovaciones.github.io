/* Burdeo Renovaciones · V1 aprobación/línea base · STAGING ficticio */
(function(root){
  function freezeBaseline({version, quote, approvedAt, channel, reference}){
    if(!version || !quote) throw new Error('VERSION_AND_QUOTE_REQUIRED');
    const commercial = JSON.parse(JSON.stringify(version));
    const internal = {
      lines:(quote.lines||[]).map(x=>({...x})),
      direct:Number(quote.direct)||0,
      indirect:Number(quote.indirect)||0,
      cost:Number(quote.cost)||0,
      targetMargin:Number(quote.targetMargin ?? quote.target ?? 0),
      expectedMargin:Number(quote.margin)||0,
      indirectPct:Number(quote.indirectPct)||0
    };
    const baseline={
      id:'BASE-'+String(version.id||version.version),
      versionId:version.id,
      versionNumber:version.version,
      project:version.project,
      approvedAt:approvedAt||new Date().toISOString(),
      approvalChannel:channel||'otro',
      approvalReference:reference||'',
      originalNet:Number(version.net)||0,
      originalVat:Number(version.vat)||0,
      originalTotal:Number(version.total)||0,
      budgetDirectCost:internal.direct,
      budgetIndirectCost:internal.indirect,
      budgetTotalCost:internal.cost,
      commercialSnapshot:commercial,
      internalSnapshot:internal
    };
    return Object.freeze({...baseline,
      commercialSnapshot:Object.freeze(baseline.commercialSnapshot),
      internalSnapshot:Object.freeze({...internal,lines:Object.freeze(internal.lines.map(Object.freeze))})
    });
  }

  function currentSales(baseline, changeOrders=[]){
    if(!baseline) return {originalNet:0,approvedAdditionalNet:0,currentNet:0,originalTotal:0,approvedAdditionalTotal:0,currentTotal:0};
    const approved=changeOrders.filter(x=>x.status==='approved');
    const additionalNet=approved.reduce((s,x)=>s+(Number(x.net)||0),0);
    const additionalTotal=approved.reduce((s,x)=>s+(Number(x.total)||0),0);
    return {
      originalNet:baseline.originalNet,
      approvedAdditionalNet:additionalNet,
      currentNet:baseline.originalNet+additionalNet,
      originalTotal:baseline.originalTotal,
      approvedAdditionalTotal:additionalTotal,
      currentTotal:baseline.originalTotal+additionalTotal
    };
  }

  function createChangeOrder({baseline,number,title,description='',net=0,vatRate=19,cost=0,status='draft'}){
    if(!baseline) throw new Error('BASELINE_REQUIRED');
    if(!title) throw new Error('TITLE_REQUIRED');
    const n=Math.max(0,Number(net)||0), v=Math.round(n*Math.max(0,Number(vatRate)||0)/100);
    return {id:`OC-${baseline.id}-${number}`,baselineId:baseline.id,number:Number(number)||1,title,description,net:n,vat:v,total:n+v,cost:Math.max(0,Number(cost)||0),status};
  }

  function runApprovalModelTests(){
    const version={id:'COT-DEMO-001',version:1,project:'Demo Cocina Norte',net:100000,vat:19000,total:119000,lines:[{description:'Mueble demo',qty:1}]};
    const quote={lines:[{family:'Materiales',qty:2,unit:20000}],direct:40000,indirect:4000,cost:44000,targetMargin:35,margin:.56,indirectPct:10};
    const b=freezeBaseline({version,quote,approvedAt:'2026-09-09T10:00:00Z',channel:'whatsapp',reference:'ACEPTACION-DEMO'});
    quote.cost=999999; version.total=999999;
    const draft=createChangeOrder({baseline:b,number:1,title:'Adicional demo',net:20000,cost:8000,status:'draft'});
    const a=currentSales(b,[draft]);
    const approved={...draft,status:'approved'};
    const c=currentSales(b,[approved]);
    const checks={
      frozen:Object.isFrozen(b)&&Object.isFrozen(b.internalSnapshot)&&Object.isFrozen(b.internalSnapshot.lines),
      originalImmutable:b.originalTotal===119000&&b.budgetTotalCost===44000,
      draftNoImpact:a.currentTotal===119000,
      approvedImpacts:c.currentNet===120000&&c.currentTotal===142800,
      originalStillSame:c.originalTotal===119000
    };
    return {ok:Object.values(checks).every(Boolean),checks};
  }

  const api={freezeBaseline,currentSales,createChangeOrder,runApprovalModelTests};
  root.BurdeoApprovalV1=api;
  if(typeof module!=='undefined'&&module.exports) module.exports=api;
})(typeof window!=='undefined'?window:globalThis);
