/** Bar data as stored in Firestore (without the document ID) */
export interface BarData {
  name: string;
  email: string;
  street: string;
  latitude: number;
  longitude: number;
  happy_hour_days: string;
  happy_hour_times: string;
  cheapest_beer_price: number;
  cheapest_wine_price: number;
  two_for_one: boolean;
  notes: string;
  description: string | null;
  ownerEmail: string;
}

/** Bar data with Firestore document ID */
export interface BarDoc extends BarData {
  id: string;
}
