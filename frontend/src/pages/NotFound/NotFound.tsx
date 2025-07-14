import { FC } from "react";
import { Link } from "react-router-dom";

const NotFound: FC = () => (
  <div>
    <h2>No such page</h2>
    <p>
      <Link to="/">Go to the home page</Link>
    </p>
  </div>
);

export default NotFound;
