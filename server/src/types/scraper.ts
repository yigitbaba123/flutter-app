export interface SizeVariant {
  name: string; // "S", "M", "38" vb.
  inStock: boolean;
}

export interface ProductDetails {
  url: string;
  brand: string;
  name: string;
  imageUrl: string;
  price?: string;
  sizes: SizeVariant[];
}

export interface IScraper {
  brand: string;
  canHandle(url: string): boolean;
  scrape(url: string): Promise<ProductDetails>;
}
