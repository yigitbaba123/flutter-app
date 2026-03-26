export function extractBrandFromUrl(url: string): string {
  const lowerUrl = url.toLowerCase();
  
  if (lowerUrl.includes('zara.com')) return 'ZARA';
  if (lowerUrl.includes('hm.com')) return 'HM';
  if (lowerUrl.includes('bershka.com')) return 'BERSHKA';
  if (lowerUrl.includes('shop.mango.com')) return 'MANGO';
  if (lowerUrl.includes('stradivarius.com')) return 'STRADIVARIUS';
  if (lowerUrl.includes('trendyol.com/milla')) return 'TRENDYOL_MILLA';
  
  return 'OTHER';
}
