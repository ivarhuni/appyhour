import { useEffect, useState, type FormEvent } from "react";
import { useNavigate, useParams, Link, useSearchParams } from "react-router-dom";
import { doc, getDoc, setDoc, addDoc, collection } from "firebase/firestore";
import { db } from "../firebase";
import { useAuth } from "../contexts/AuthContext";
import type { BarData } from "../types";

const EMPTY_BAR: BarData = {
  name: "",
  email: "",
  street: "",
  latitude: 64.1466,
  longitude: -21.9426,
  happy_hour_days: "",
  happy_hour_times: "",
  cheapest_beer_price: 0,
  cheapest_wine_price: 0,
  two_for_one: false,
  notes: "",
  description: "",
  ownerEmail: "",
};

export function BarEditorPage() {
  const { barId } = useParams();
  const [searchParams] = useSearchParams();
  const isNew = !barId || barId === "new";
  const navigate = useNavigate();
  const { user, isAdmin } = useAuth();

  const backTo = searchParams.get("from") === "admin" ? "/admin" : "/dashboard";

  const [form, setForm] = useState<BarData>({ ...EMPTY_BAR });
  const [loading, setLoading] = useState(!isNew);
  const [saving, setSaving] = useState(false);
  const [error, setError] = useState("");

  useEffect(() => {
    if (isNew || !barId) return;

    async function loadBar() {
      try {
        const snap = await getDoc(doc(db, "bars", barId!));
        if (!snap.exists()) {
          navigate(backTo, { replace: true });
          return;
        }
        const data = snap.data() as BarData;
        if (!isAdmin && data.ownerEmail !== user?.email) {
          navigate("/dashboard", { replace: true });
          return;
        }
        setForm(data);
      } catch {
        setError("Failed to load bar. Please go back and try again.");
      } finally {
        setLoading(false);
      }
    }

    loadBar();
  }, [barId, isNew, navigate, user, isAdmin, backTo]);

  function update(field: keyof BarData, value: string | number | boolean) {
    setForm((prev) => ({ ...prev, [field]: value }));
  }

  async function handleSubmit(e: FormEvent) {
    e.preventDefault();
    if (!user) return;
    setError("");
    setSaving(true);

    try {
      const data: BarData = {
        ...form,
        ownerEmail: isAdmin ? form.ownerEmail : (user.email ?? ""),
      };

      if (isNew) {
        await addDoc(collection(db, "bars"), data);
      } else {
        await setDoc(doc(db, "bars", barId!), data);
      }
      navigate(backTo);
    } catch {
      setError("Failed to save. Please try again.");
    } finally {
      setSaving(false);
    }
  }

  if (loading) {
    return (
      <div className="loading">
        <div className="spinner" />
      </div>
    );
  }

  return (
    <div className="page editor-page">
      <header className="editor-header">
        <Link to={backTo} className="back-link">
          &larr; Back
        </Link>
        <h1>{isNew ? "Add New Bar" : `Edit ${form.name || "Bar"}`}</h1>
      </header>

      <form onSubmit={handleSubmit} className="bar-form">
        {error && <div className="error-banner">{error}</div>}

        {isAdmin && (
          <fieldset>
            <legend>Ownership</legend>
            <label>
              Owner Email *
              <input
                type="email"
                value={form.ownerEmail}
                onChange={(e) => update("ownerEmail", e.target.value)}
                required
                placeholder="barowner@example.com"
              />
            </label>
          </fieldset>
        )}

        <fieldset>
          <legend>Basic Info</legend>

          <label>
            Bar / Restaurant Name *
            <input
              type="text"
              value={form.name}
              onChange={(e) => update("name", e.target.value)}
              required
              maxLength={200}
            />
          </label>

          <label>
            Contact Email *
            <input
              type="email"
              value={form.email}
              onChange={(e) => update("email", e.target.value)}
              required
            />
          </label>

          <label>
            Street Address *
            <input
              type="text"
              value={form.street}
              onChange={(e) => update("street", e.target.value)}
              required
            />
          </label>

          <div className="field-row">
            <label>
              Latitude *
              <input
                type="number"
                step="any"
                min={-90}
                max={90}
                value={form.latitude}
                onChange={(e) => update("latitude", parseFloat(e.target.value) || 0)}
                required
              />
            </label>
            <label>
              Longitude *
              <input
                type="number"
                step="any"
                min={-180}
                max={180}
                value={form.longitude}
                onChange={(e) => update("longitude", parseFloat(e.target.value) || 0)}
                required
              />
            </label>
          </div>
        </fieldset>

        <fieldset>
          <legend>Happy Hour</legend>

          <label>
            Happy Hour Days *
            <input
              type="text"
              value={form.happy_hour_days}
              onChange={(e) => update("happy_hour_days", e.target.value)}
              required
              placeholder="e.g. Every day, Mon-Fri"
            />
          </label>

          <label>
            Happy Hour Times *
            <input
              type="text"
              value={form.happy_hour_times}
              onChange={(e) => update("happy_hour_times", e.target.value)}
              required
              placeholder="e.g. 15:00 - 17:00"
              pattern="\d{2}:\d{2}\s*-\s*\d{2}:\d{2}"
              title="Format: HH:MM - HH:MM (24-hour)"
            />
          </label>

          <div className="field-row">
            <label>
              Cheapest Beer (ISK) *
              <input
                type="number"
                min={0}
                step={1}
                value={form.cheapest_beer_price}
                onChange={(e) => update("cheapest_beer_price", parseInt(e.target.value) || 0)}
                required
              />
            </label>
            <label>
              Cheapest Wine (ISK) *
              <input
                type="number"
                min={0}
                step={1}
                value={form.cheapest_wine_price}
                onChange={(e) => update("cheapest_wine_price", parseInt(e.target.value) || 0)}
                required
              />
            </label>
          </div>

          <label className="checkbox-label">
            <input
              type="checkbox"
              checked={form.two_for_one}
              onChange={(e) => update("two_for_one", e.target.checked)}
            />
            2-for-1 deals available
          </label>
        </fieldset>

        <fieldset>
          <legend>Additional Info</legend>

          <label>
            Notes
            <textarea
              value={form.notes}
              onChange={(e) => update("notes", e.target.value)}
              rows={3}
              placeholder="Special deals, atmosphere, etc."
            />
          </label>

          <label>
            Featured Description
            <textarea
              value={form.description ?? ""}
              onChange={(e) => update("description", e.target.value || "")}
              rows={2}
              placeholder="Optional description for featured listings"
            />
          </label>
        </fieldset>

        <div className="form-actions">
          <button type="submit" className="btn btn-primary" disabled={saving}>
            {saving ? "Saving..." : isNew ? "Add Bar" : "Save Changes"}
          </button>
          <Link to={backTo} className="btn btn-secondary">
            Cancel
          </Link>
        </div>
      </form>
    </div>
  );
}
