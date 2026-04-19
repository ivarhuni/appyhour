import { useEffect, useState } from "react";
import { Link } from "react-router-dom";
import { collection, onSnapshot, deleteDoc, doc } from "firebase/firestore";
import { db } from "../firebase";
import { useAuth } from "../contexts/AuthContext";
import type { BarDoc } from "../types";

export function AdminPage() {
  const { user, logout } = useAuth();
  const [bars, setBars] = useState<BarDoc[]>([]);
  const [loading, setLoading] = useState(true);
  const [deleting, setDeleting] = useState<string | null>(null);

  useEffect(() => {
    const unsubscribe = onSnapshot(
      collection(db, "bars"),
      (snapshot) => {
        const barDocs: BarDoc[] = snapshot.docs.map((d) => ({
          id: d.id,
          ...(d.data() as Omit<BarDoc, "id">),
        }));
        barDocs.sort((a, b) => a.name.localeCompare(b.name));
        setBars(barDocs);
        setLoading(false);
      },
      () => {
        setLoading(false);
      }
    );
    return unsubscribe;
  }, []);

  async function handleDelete(barId: string, barName: string) {
    if (!confirm(`Delete "${barName}"? This cannot be undone.`)) return;
    setDeleting(barId);
    try {
      await deleteDoc(doc(db, "bars", barId));
    } finally {
      setDeleting(null);
    }
  }

  return (
    <div className="page dashboard-page">
      <header className="dashboard-header">
        <div>
          <h1>Admin &mdash; All Bars</h1>
          <p className="subtitle">{user?.email}</p>
        </div>
        <div className="header-actions">
          <Link to="/bars/new?from=admin" className="btn btn-primary">
            + Add Bar
          </Link>
          <button onClick={logout} className="btn btn-secondary">
            Sign Out
          </button>
        </div>
      </header>

      {loading ? (
        <div className="loading">
          <div className="spinner" />
        </div>
      ) : bars.length === 0 ? (
        <div className="empty-state">
          <p>No bars yet.</p>
          <Link to="/bars/new?from=admin" className="btn btn-primary">
            Add the First Bar
          </Link>
        </div>
      ) : (
        <div className="bar-grid">
          {bars.map((bar) => (
            <div key={bar.id} className="bar-card">
              <div className="bar-card-header">
                <h2>{bar.name}</h2>
                <span className="owner-tag">{bar.ownerEmail || "unassigned"}</span>
              </div>
              <p className="bar-address">{bar.street}</p>
              <div className="bar-details">
                <span>
                  {bar.happy_hour_days} &middot; {bar.happy_hour_times}
                </span>
                <span>
                  Beer {bar.cheapest_beer_price} ISK &middot; Wine{" "}
                  {bar.cheapest_wine_price} ISK
                </span>
                {bar.two_for_one && <span className="badge">2-for-1</span>}
              </div>
              {bar.notes && <p className="bar-notes">{bar.notes}</p>}
              <div className="bar-actions">
                <Link
                  to={`/bars/${bar.id}/edit?from=admin`}
                  className="btn btn-small"
                >
                  Edit
                </Link>
                <button
                  onClick={() => handleDelete(bar.id, bar.name)}
                  className="btn btn-small btn-danger"
                  disabled={deleting === bar.id}
                >
                  {deleting === bar.id ? "Deleting..." : "Delete"}
                </button>
              </div>
            </div>
          ))}
        </div>
      )}
    </div>
  );
}
